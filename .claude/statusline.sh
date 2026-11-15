#!/usr/bin/env bash
# Claude Code status line.
# Optimized: one jq process parses every field, one git process yields branch +
# dirty state, and all formatting uses bash builtins (no per-field subshells).
#
# Portable: Linux, macOS (stock bash 3.2) and Windows (Git Bash, which Claude
# Code uses for command hooks/status lines). Needs only bash + jq; git optional.
# Keep this file LF-only (a CRLF checkout breaks bash): `*.sh text eol=lf`.
set -u

input=$(cat)

if ! command -v jq >/dev/null 2>&1; then
  printf 'statusline: jq not found (install jq)'
  exit 0
fi

# ── tool-run state, written in real time by hooks/tool-tracker.sh ────────
# State dir must match hooks/tool-tracker.sh. XDG_RUNTIME_DIR (Linux),
# TMPDIR (macOS per-user temp), else /tmp (Git Bash maps it to %TEMP%).
sid=""
[[ $input =~ \"session_id\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]] && sid=${BASH_REMATCH[1]//[^A-Za-z0-9_-]/_}
state_base=${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}
tool_state="${state_base%/}/claude-statusline/$sid.json"
[ -n "$sid" ] && [ -s "$tool_state" ] || tool_state=/dev/null

US=$'\x1f'
IFS="$US" read -r \
  model agent cwd worktree lines_add lines_rm cost dur_ms \
  ctx_pct in_tok out_tok ctx_size thinking effort style fast \
  pc_present pc_warm pc_observed pc_ttl pc_expires pc_hit pc_misses \
  pc_requests pc_recache pc_last_cause \
  t_total t_errors t_top t_nrun r_name r_arg r_ag r_secs \
  l_name l_arg l_ag l_res l_dur l_err \
  < <(jq -j --slurpfile st "$tool_state" '
  def s: if . == null then "" else tostring end;
  def tok: if . == null then ""
           elif . < 1000 then tostring
           elif . < 1000000 then ((. / 100 | floor) / 10 | tostring) + "k"
           else ((. / 100000 | floor) / 10 | tostring) + "M" end;
  def ms: if . == null then ""
          elif . < 1000 then "\(.)ms"
          elif . < 60000 then "\(. / 100 | floor | . / 10)s"
          else "\(. / 60000 | floor)m\(. % 60000 / 1000 | floor | tostring | if length < 2 then "0" + . else . end)s" end;
  ($st[0] // {}) as $t
  | ($t.running // {} | [.[]] | sort_by(.t) | last) as $run
  | .prompt_cache as $pc |
  [
    (.model.display_name | s),
    (.agent.name | s),
    ((.workspace.current_dir // .cwd) | s),
    (.workspace.git_worktree | s),
    (.cost.total_lines_added // 0 | s),
    (.cost.total_lines_removed // 0 | s),
    # Locale-independent "$1.23" (printf %.2f prints "1,23" under some locales).
    (.cost.total_cost_usd // 0 | . * 100 | round
       | "$\(. / 100 | floor).\(. % 100 | tostring | if length < 2 then "0" + . else . end)"),
    (.cost.total_duration_ms // 0 | floor | s),
    (.context_window.used_percentage // 0 | floor | s),
    (.context_window.total_input_tokens // 0 | tok),
    (.context_window.total_output_tokens // 0 | tok),
    (.context_window.context_window_size | tok),
    (.thinking.enabled | s),
    (.effort.level | s),
    (.output_style.name | s),
    (.fast_mode | s),
    (if $pc == null then "0" else "1" end),
    ($pc.warm | s),
    ($pc.caching_observed | s),
    ($pc.ttl | s),
    ($pc.expires_at | if . == null then "" else floor | tostring end),
    ($pc.hit_ratio | if . == null then "" else (. * 100 | round | tostring) end),
    ($pc.misses // 0 | s),
    ($pc.requests // 0 | s),
    ($pc.recache_tokens_if_cold | tok),
    ($pc.last_miss_cause.causes[0]? | s),
    ($t.total // 0 | s),
    ($t.errors // 0 | s),
    ($t.counts // {} | to_entries | sort_by(-.value) | .[0:3]
       | map("\(.key)×\(.value)") | join(" ")),
    ($t.running // {} | length | s),
    ($run.n | s), ($run.a | s), ($run.ag | s),
    (if $run then (now - $run.t | floor | s) else "" end),
    ($t.last.n | s), ($t.last.a | s), ($t.last.ag | s), ($t.last.r | s),
    ($t.last.ms | ms), ($t.last.e | s)
  ] | join("\u001f")' <<<"$input" 2>"${STATUSLINE_DEBUG:-/dev/null}")

# ── helpers (builtins only) ──────────────────────────────────────────────
out=""
emit() { # emit <sgr> <text>
  if [ -n "$1" ]; then out+=$'\e['"$1m$2"$'\e[0m'; else out+="$2"; fi
}

if [ -n "${STATUSLINE_CLOCK_OVERRIDE:-}" ]; then
  now=$STATUSLINE_CLOCK_OVERRIDE
else
  # printf %(...)T needs bash >= 4.2; macOS ships 3.2, so fall back to date.
  if (( BASH_VERSINFO[0] > 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 2) )); then
    printf -v now '%(%s)T' -1
  else
    now=$(date +%s)
  fi
fi
l_err=${l_err%$'\r'}   # in case a Windows jq build emits CRLF

# ~-abbreviate the home folder. Handles /home/u, /Users/u (macOS) and
# C:\Users\u (Windows; Git Bash $HOME is /c/Users/u so it never prefix-matches).
home=${HOME%/}
if [ -n "$home" ] && [[ "$cwd" == "$home"* ]]; then
  dir="~${cwd#"$home"}"
elif [[ $cwd =~ ^([A-Za-z]:)?[\\/](Users|home)[\\/][^\\/]+(.*)$ ]]; then
  dir="~${BASH_REMATCH[3]}"
else
  dir=$cwd
fi
dir=${dir//\\//}

# One git call: branch + dirty. --no-optional-locks avoids index lock contention.
branch="" dirty=0
if [ -n "$cwd" ] && command -v git >/dev/null 2>&1; then
  while IFS= read -r line; do
    case $line in
      '# branch.head '*) branch=${line#\# branch.head } ;;
      '#'*) ;;
      *) dirty=1; break ;;
    esac
  done < <(git -C "$cwd" --no-optional-locks status --porcelain=v2 --branch 2>/dev/null)
fi
[ -z "$branch" ] && branch=$worktree

bar="" p=${ctx_pct:-0}
(( p < 0 )) && p=0; (( p > 100 )) && p=100
filled=$(( (p * 18 + 50) / 100 ))
for ((i = 0; i < 18; i++)); do
  if (( i < filled )); then bar+='▮'; else bar+='▯'; fi
done

total=$(( ${dur_ms:-0} / 1000 ))
if (( total < 60 )); then dur="${total}s"
elif (( total < 3600 )); then
  dur="$((total / 60))m"; (( total % 60 )) && dur+=" $((total % 60))s"
else
  dur="$((total / 3600))h"; (( total % 3600 / 60 )) && dur+=" $((total % 3600 / 60))m"
fi

cost_fmt=${cost:-\$0.00}

# ── line 1: model · agent · dir · branch · diff ──────────────────────────
emit '' '🤖 '
emit '1;38;2;252;231;243;48;2;121;57;123' " $model "
if [ -n "$agent" ]; then
  emit '' ' 🕵️ '
  emit '1;38;2;125;211;252' "$agent"
fi
emit '' ' 📁 '
emit '1;38;2;253;186;116' "$dir"
if [ -n "$branch" ]; then
  emit '' ' 🌳 '
  emit '3;38;2;254;215;170' "$branch"
  if (( dirty )); then emit '1;38;2;251;191;36' ' ◆'; else emit '2;38;2;251;146;60' ' ◇'; fi
fi
emit '38;2;100;229;105' " +$lines_add"
emit '38;2;242;102;102' " -$lines_rm"
out+=$'\n'

# ── line 2: context window + prompt cache ────────────────────────────────
emit '' '🧠 '
emit '38;2;255;185;111' "$bar"
emit '1' " ${ctx_pct}%"
emit '' ' 🚀 '
emit '1' "in ${in_tok}"
[ -n "$ctx_size" ] && emit '2' "/${ctx_size}"
emit '' ' · '
emit '1' "out ${out_tok}"

if [ "$pc_present" = 1 ]; then
  emit '' '  '
  if [ "$pc_observed" = false ]; then
    emit '2' '💾 cache n/a'
  else
    if [ "$pc_warm" = true ]; then
      emit '1;38;2;74;222;128' "🔥 warm"
      [ -n "$pc_ttl" ] && emit '2;38;2;74;222;128' " ${pc_ttl}"
      if [ -n "$pc_expires" ] && (( pc_expires > now )); then
        left=$((pc_expires - now))
        if (( left < 60 )); then emit '2;38;2;74;222;128' " T-${left}s"
        else emit '2;38;2;74;222;128' " T-$((left / 60))m"; fi
      fi
    else
      emit '1;38;2;96;165;250' '🧊 cold'
      [ -n "$pc_recache" ] && emit '2;38;2;96;165;250' " ↻${pc_recache}"
    fi
    [ -n "$pc_hit" ] && emit '38;2;254;243;199' " ${pc_hit}% hit"
    if (( ${pc_misses:-0} > 0 )); then
      emit '38;2;242;102;102' " ${pc_misses}/${pc_requests} miss"
      [ -n "$pc_last_cause" ] && emit '2;38;2;242;102;102' " (${pc_last_cause})"
    else
      emit '2' " 0 miss"
    fi
  fi
fi
out+=$'\n'

# ── line 3: tool runs (live while a tool executes) ───────────────────────
if (( ${t_total:-0} > 0 )); then
  emit '' '🔧 '
  if (( ${t_nrun:-0} > 0 )); then
    emit '1;38;2;251;191;36' "▶ ${r_name}"
    [ -n "$r_ag" ] && emit '38;2;125;211;252' " [${r_ag}]"
    emit '1;38;2;251;191;36' " ${r_secs}s"
    [ -n "$r_arg" ] && emit '2' " ${r_arg}"
    (( t_nrun > 1 )) && emit '1;38;2;251;191;36' " +$((t_nrun - 1)) more"
  elif [ -n "$l_name" ]; then
    case $l_res in
      ok)  emit '38;2;100;229;105' "✓ ${l_name}" ;;
      int) emit '38;2;251;146;60' "⊘ ${l_name}" ;;
      *)   emit '38;2;242;102;102' "✗ ${l_name}" ;;
    esac
    [ -n "$l_ag" ] && emit '38;2;125;211;252' " [${l_ag}]"
    [ -n "$l_dur" ] && emit '' " ${l_dur}"
    [ -n "$l_arg" ] && emit '2' " ${l_arg}"
    [ -n "$l_err" ] && emit '38;2;242;102;102' " — ${l_err}"
  fi
  emit '2' "  │ ${t_total} calls"
  [ -n "$t_top" ] && emit '38;2;196;181;253' " ${t_top}"
  if (( ${t_errors:-0} > 0 )); then emit '38;2;242;102;102' " ✗${t_errors}"; fi
  out+=$'\n'
fi

# ── line 4: effort · style · fast · mood · cost · duration ───────────────
emit '1;38;2;236;74;161' '💪 '
[ "$thinking" = true ] && emit '1;38;2;236;74;161' "$effort"
if [ -n "$style" ] && [ "$style" != default ]; then
  emit '' ' '
  emit '3;38;2;240;171;252' "✨ $style"
fi
[ "$fast" = true ] && emit '1;38;2;11;16;26;48;2;253;224;71' ' ⚡ '
moods=(building thinking shipping exploring)
emit '3;38;2;251;207;232' " · ${moods[(now / 5) % 4]}"
emit '38;2;254;243;199' " 💰 $cost_fmt"
emit '2;38;2;253;186;116' " ⏱️ $dur"

printf '%s' "$out"
