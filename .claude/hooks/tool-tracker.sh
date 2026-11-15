#!/usr/bin/env bash
# Records tool-call lifecycle events for the status line.
#
# Wired in settings.json to: PreToolUse, PostToolUse, PostToolUseFailure,
# UserPromptSubmit, Stop, SessionEnd. Each event costs one jq process. Parallel
# tool calls fire hooks concurrently, so updates are serialized with a lock and
# the state file is replaced atomically. Never prints to stdout, always exits 0,
# so it cannot block or alter a tool call.
#
# Portable: Linux, macOS (stock bash 3.2) and Windows (Git Bash). Needs only
# bash + jq. No flock (absent on macOS/Git Bash): the lock is an atomic mkdir.
# Keep this file LF-only (a CRLF checkout breaks bash): `*.sh text eol=lf`.
set -u

command -v jq >/dev/null 2>&1 || exit 0

input=$(cat)
[[ $input =~ \"session_id\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]] || exit 0
sid=${BASH_REMATCH[1]//[^A-Za-z0-9_-]/_}

# Must match statusline.sh: XDG_RUNTIME_DIR (Linux), TMPDIR (macOS), /tmp.
state_base=${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}
dir="${state_base%/}/claude-statusline"
[ -d "$dir" ] || mkdir -p -m 700 "$dir" 2>/dev/null || exit 0
state="$dir/$sid.json"
lock="$state.lock"

if [[ $input =~ \"hook_event_name\"[[:space:]]*:[[:space:]]*\"SessionEnd\" ]]; then
  rm -rf "$state" "$lock"
  exit 0
fi

# mkdir is atomic on every OS/filesystem. Wait up to ~2s; a lock older than
# that is assumed orphaned by a killed hook and is taken over.
tries=0
until mkdir "$lock" 2>/dev/null; do
  tries=$((tries + 1))
  if (( tries >= 200 )); then
    rm -rf "$lock"; mkdir "$lock" 2>/dev/null || exit 0; break
  fi
  sleep 0.01
done
trap 'rm -rf "$lock"' EXIT

st_in=/dev/null
[ -s "$state" ] && st_in=$state
tmp="$state.$$"

if jq -c --slurpfile st "$st_in" '
  def clip($n): if length > $n then .[0:$n-1] + "…" else . end;
  def argsum:
    (.description // .command // .file_path // .notebook_path // .pattern
     // .query // .url // .skill // .subagent_type // .prompt // "")
    | tostring | gsub("[\\r\\n\\t\u001f]"; " ")
    # Absolute POSIX or Windows path (/x/y, C:\x\y, C:/x/y) -> basename.
    | if test("^([A-Za-z]:)?[\\\\/]") then sub(".*[\\\\/]"; "") else . end
    | clip(48);

  . as $h
  | $h.hook_event_name as $ev
  | ($st[0] // {})
  | .total //= 0 | .errors //= 0 | .counts //= {} | .running //= {}
  # Drop entries orphaned by a crash or an uncaught cancel (older than 1h).
  | .running |= with_entries(select(.value.t > (now - 3600)))
  | if $ev == "PreToolUse" then
      .total += 1
      | .counts[$h.tool_name] += 1
      | .running[$h.tool_use_id] = {
          n: $h.tool_name, a: ($h.tool_input | argsum), t: now,
          ag: $h.agent_type, sub: ($h.agent_id != null) }
    elif $ev == "PostToolUse" or $ev == "PostToolUseFailure" then
      .running[$h.tool_use_id] as $r
      | (if $ev == "PostToolUse" then "ok"
         elif $h.is_interrupt == true then "int" else "err" end) as $res
      | del(.running[$h.tool_use_id])
      | (if $res == "ok" then . else .errors += 1 end)
      | .last = {
          n: $h.tool_name,
          a: ($r.a // ($h.tool_input | argsum)),
          ag: $h.agent_type, sub: ($h.agent_id != null), r: $res,
          ms: ($h.duration_ms // (if $r then ((now - $r.t) * 1000 | floor) else null end)),
          e: (if $res == "ok" then null
              else ($h.error // "" | tostring | split("\n")[0] | sub("\r$"; "") | clip(40)) end) }
    elif $ev == "UserPromptSubmit" or $ev == "Stop" then
      # Main turn ended or was interrupted: its tools are no longer running.
      # Keep subagent entries — background agents can outlive the turn.
      .running |= with_entries(select(.value.sub))
    else . end
' <<<"$input" > "$tmp" 2>/dev/null && [ -s "$tmp" ]; then
  # On Windows, replacing a file the status line has open can fail briefly.
  for _ in 1 2 3 4 5; do
    mv -f "$tmp" "$state" 2>/dev/null && break
    sleep 0.02
  done
fi
rm -f "$tmp"
exit 0
