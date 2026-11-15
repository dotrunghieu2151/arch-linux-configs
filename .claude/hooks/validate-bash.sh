#!/usr/bin/env bash
# PreToolUse hook for the Bash tool: denies dangerous shell commands.
# Works on Linux, macOS (bash 3.2 + BSD grep) and Windows (Git Bash running
# bash, PowerShell or cmd command lines). Only POSIX ERE is used: no \s, \b or -P.
set -uo pipefail

INPUT=$(cat)

deny() {
  # Reasons are fixed strings with no quotes or backslashes, so they are JSON-safe.
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$1"
  exit 0
}

# --- Extract tool_input.command (jq, else Python). Fail closed if neither works.
extract_py='import json,sys; print((json.load(sys.stdin).get("tool_input") or {}).get("command") or "")'
if command -v jq >/dev/null 2>&1; then
  COMMAND=$(jq -r '.tool_input.command // empty' <<<"$INPUT") || deny "validate-bash: could not parse hook input"
elif COMMAND=$(python3 -c "$extract_py" <<<"$INPUT" 2>/dev/null); then :
elif COMMAND=$(python -c "$extract_py" <<<"$INPUT" 2>/dev/null); then :
else
  deny "validate-bash: install jq or Python so commands can be checked"
fi
[[ -z "$COMMAND" ]] && exit 0

# Herestrings instead of pipes: with pipefail, an early grep -q exit could
# SIGPIPE the writer and turn a match into a false negative.
# grep status >1 means an error (bad regex, missing grep): fail closed.
match() {
  local s=0
  grep -q "$1" -- "$2" <<<"$COMMAND" || s=$?
  ((s > 1)) && deny "validate-bash: grep failed, cannot check command"
  return "$s"
}
has()  { match -E  "$1"; }   # case-sensitive (POSIX tools)
hasi() { match -iE "$1"; }   # case-insensitive (Windows tools)

# --- Shared regex fragments
# C: command position — start, after ; & | ( { `, or inside bash/sh -c,
#    powershell -Command, cmd /c; optionally behind wrappers like env/xargs.
C="(^|[;&|({\`]|(ba|z|da|k)?sh[[:space:]]+-c[[:space:]]+[\"']?|([pP]ower[sS]hell|pwsh)(\.exe)?[[:space:]]+([^;&|]*[[:space:]])?-([cC]|[cC]ommand)[[:space:]]+[\"']?|cmd(\.exe)?[[:space:]]+/[cCkK][[:space:]]+[\"']?)[[:space:]]*((sudo|doas|env|command|builtin|exec|nohup|time|nice|xargs)([[:space:]]+-[^[:space:]]+)*[[:space:]]+)*"
# E: end of a word/argument.
E="([[:space:];&|)\`\"']|$)"
# G: "git" plus global options such as -C <dir> or --no-pager.
G="git([[:space:]]+-[cC][[:space:]]+[^[:space:]]+|[[:space:]]+--?[a-zA-Z-]+(=[^[:space:]]+)?)*[[:space:]]+"
# A: zero or more arguments before the one we care about.
A="([[:space:]]+[^;&|[:space:]]+)*[[:space:]]+"
# T: critical delete targets — filesystem root, home, top-level system dirs,
#    Git Bash drive roots, Windows drive roots/system dirs and env vars.
T="[\"']?(/|/\*|\\\\|~|~/\*?|\\\$HOME/?\*?|\\\$\{HOME\}/?\*?|/(bin|boot|dev|etc|lib|lib64|opt|proc|root|sbin|srv|sys|usr|var|home|Users|System|Library|Applications|Volumes|private)/?\*?|/[a-z]/\*?|[a-z]:[\\\\/]?\*?|[a-z]:[\\\\/](Windows|Users|ProgramData|Program Files[^\\\\/\"']*)[\\\\/]?\*?|\\\$env:(SystemRoot|windir|SystemDrive|USERPROFILE|ProgramFiles|HOMEDRIVE)[\\\\/]?\*?|%(SystemRoot|windir|SystemDrive|USERPROFILE|ProgramFiles|HOMEDRIVE)%[\\\\/]?\*?)[\"']?"

# ===================== Filesystem destruction (all platforms)
hasi "${C}(rm|rmdir|rd|del|erase|ri|Remove-Item)${A}${T}${E}" \
  && deny "Deleting the filesystem root, home or a system directory is blocked"
has "--no-preserve-root" \
  && deny "rm --no-preserve-root is blocked"
has "${C}find[[:space:]]+[\"']?(/|~|\\\$HOME)[\"']?[[:space:]].*(-delete|-exec[[:space:]]+rm)" \
  && deny "find with -delete or -exec rm on root or home is blocked"
has "${C}(chmod|chown|chgrp)${A}(-R|--recursive|-[a-zA-Z]*R[a-zA-Z]*)${A}([^[:space:]]+[[:space:]]+)?[\"']?(/|/\*|~|\\\$HOME)[\"']?${E}" \
  && deny "Recursive chmod or chown on root or home is blocked"
has "${C}mv${A}[^;&|]*[[:space:]]/dev/null${E}" \
  && deny "Moving files to /dev/null destroys them and is blocked"
has ">[[:space:]]*[\"']?/(etc|boot|bin|sbin|usr|lib|lib64|System)/" \
  && deny "Redirecting output into system directories is blocked"

# ===================== Disks and partitions
has "${C}(mkfs(\.[a-z0-9]+)?|mke2fs|mkswap|wipefs|newfs(_[a-z]+)?)${E}" \
  && deny "Creating or wiping filesystems is blocked"
has "${C}(fdisk|sfdisk|cfdisk|parted|gdisk|sgdisk|shred|blkdiscard)${A}/dev/" \
  && deny "Partitioning or shredding block devices is blocked"
hasi "(of=|>[[:space:]]*)[\"']?(/dev/(sd|hd|vd|xvd|nvme|mmcblk|disk|rdisk|md|dm-|mapper/)|\\\\\\\\\.\\\\PhysicalDrive)" \
  && deny "Writing raw data to a disk device is blocked"
has "${C}diskutil[[:space:]]+(.*[[:space:]])?(erase[a-zA-Z]*|zeroDisk|randomDisk|secureErase|reformat|partitionDisk|apfs[[:space:]]+delete[a-zA-Z]*)${E}" \
  && deny "Erasing or repartitioning disks with diskutil is blocked"
hasi "${C}(format(\.com)?[[:space:]]+[a-z]:|Format-Volume|Clear-Disk|Initialize-Disk|Remove-Partition|Set-Partition|diskpart)${E}" \
  && deny "Formatting or repartitioning Windows disks is blocked"
hasi "${C}cipher(\.exe)?[[:space:]]+(.*[[:space:]])?/w" \
  && deny "cipher /w (wipe free space) is blocked"

# ===================== System integrity, boot and backups
has ":\(\)[[:space:]]*\{[[:space:]]*:[[:space:]]*\|[[:space:]]*:[[:space:]]*&" \
  && deny "Fork bomb detected"
hasi "${C}(shutdown|reboot|halt|poweroff|Stop-Computer|Restart-Computer)${E}" \
  && deny "Shutting down or rebooting the machine is blocked"
has "${C}(init|telinit)[[:space:]]+[06]${E}|${C}systemctl[[:space:]]+(.*[[:space:]])?(poweroff|reboot|halt|kexec|emergency|rescue)${E}" \
  && deny "Changing the system runlevel is blocked"
has "${C}kill(all)?([[:space:]]+-[^[:space:]]+)*[[:space:]]+-1[[:space:]]*($|[;&|])" \
  && deny "kill -1 (signal every process) is blocked"
has "${C}crontab([[:space:]]+-[^[:space:]]+)*[[:space:]]+-[a-zA-Z]*r" \
  && deny "crontab -r (delete all cron jobs) is blocked"
has "${C}(csrutil[[:space:]]+(disable|clear)|spctl[[:space:]]+--(master|global)-disable|nvram[[:space:]]+-c)" \
  && deny "Disabling macOS security protections is blocked"
hasi "${C}(bcdedit|vssadmin[^;&|]*delete|wmic[^;&|]*shadowcopy[^;&|]*delete|wbadmin[^;&|]*delete|reg(\.exe)?[[:space:]]+delete[[:space:]]+[\"']?HK(LM|EY_LOCAL_MACHINE|CR|EY_CLASSES_ROOT)|Set-ExecutionPolicy[^;&|]*(Unrestricted|Bypass)|Disable-ComputerRestore)" \
  && deny "Modifying Windows boot config, shadow copies, HKLM or execution policy is blocked"
hasi "(Remove-Item|ri|rm|del)${A}[\"']?(HKLM|HKCR|Registry::HKEY_LOCAL_MACHINE):" \
  && deny "Deleting HKLM or HKCR registry keys is blocked"

# ===================== Remote code execution
has "(curl|wget|fetch)[^|]*\|[[:space:]]*(sudo[[:space:]]+)?(env[[:space:]]+)?((ba|z|da|k|fi|c|tc)?sh|python[0-9.]*|perl|ruby|node)${E}" \
  && deny "Piping downloaded content into a shell or interpreter is blocked"
has "(ba|z|da|k)?sh[[:space:]]+(-c[[:space:]]+)?[\"']?(<\(|\\\$\(|\`)[[:space:]]*(curl|wget)" \
  && deny "Executing downloaded scripts via process substitution is blocked"
hasi "(iwr|irm|curl|wget|Invoke-WebRequest|Invoke-RestMethod|DownloadString|DownloadFile)[^|]*\|[[:space:]]*(iex|Invoke-Expression)${E}|(iex|Invoke-Expression)[[:space:](\$]*(iwr|irm|Invoke-WebRequest|Invoke-RestMethod|New-Object[[:space:]]+(System\.)?Net\.WebClient)" \
  && deny "Invoke-Expression on downloaded content is blocked"

# ===================== Git
has "${G}push${A}(-f|--force|-[a-zA-Z]*f[a-zA-Z]*)${E}" \
  && deny "git push --force is blocked. Use --force-with-lease"
has "${G}push${A}([^;&|]*[[:space:]])?\+[^[:space:]]" \
  && deny "Force push via +refspec is blocked. Use --force-with-lease"
has "${G}push${A}([^;&|]*[[:space:]])?--mirror${E}" \
  && deny "git push --mirror is blocked"
has "${G}reset${A}([^;&|]*[[:space:]])?--hard${E}" \
  && deny "git reset --hard discards work and is blocked. Use git stash"
has "${G}clean${A}([^;&|]*[[:space:]])?(-[a-zA-Z]*f[a-zA-Z]*|--force)${E}" \
  && deny "git clean -f deletes untracked files and is blocked. Use git clean -n to preview"
has "${G}add${A}([^;&|]*[[:space:]])?(-A|--all|\.|\*)${E}" \
  && deny "git add -A is blocked. Stage specific files instead"

# ===================== Privilege escalation
has "${C}(sudo|doas|pkexec|su)${E}" \
  && deny "Privilege escalation (sudo, doas, pkexec, su) is blocked in automated mode"
hasi "${C}runas(\.exe)?${E}|Start-Process[^;&|]*-Verb[[:space:]]+[\"']?RunAs" \
  && deny "Windows elevation (runas, Start-Process -Verb RunAs) is blocked"

# ===================== Preferred CLI tools (see rules/common/cli-tools.md)
# Matches at command position only, so git grep and arguments named find pass.
# P: optional directory prefix such as /usr/bin/.
P="([^[:space:];&|]*/)?"
has "${C}${P}(grep|egrep|fgrep|rgrep)${E}" \
  && deny "grep is blocked. Use rg, or the Grep tool"
has "${C}${P}find${E}" \
  && deny "find is blocked. Use fd --hidden --no-ignore"

exit 0
