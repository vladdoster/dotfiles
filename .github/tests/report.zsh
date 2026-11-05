# report.zsh -- record check results for the log and, in GitHub Actions, the run page.
# Sourced by the tests. Each result prints as it happens: PASS in green, FAIL in red. In GitHub
# Actions (GITHUB_ACTIONS=true) each failure is also an error annotation, and `report` appends a
# job summary with GitHub alerts to $GITHUB_STEP_SUMMARY. See
# https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands

integer pass=0 fail=0
typeset -ga report_rows report_failures
typeset -g report_area='' report_file=''
[[ ${GITHUB_ACTIONS-} == true ]] && typeset -gri gha=1 || typeset -gri gha=0
# The Actions log renders ANSI colors, as a terminal does.
if [[ -t 1 ]] || ((gha)); then
  typeset -gr report_pass=$'\e[32mPASS\e[0m' report_fail=$'\e[31mFAIL\e[0m'
else
  typeset -gr report_pass=PASS report_fail=FAIL
fi

# command_data <text> / command_property <text> -- escape text for a workflow command, as the
# actions toolkit does: a message escapes %, CR, and LF; a property value also escapes : and ,.
command_data() {
  local s=${1//\%/%25}
  s=${s//$'\r'/%0D}
  print -rn -- ${s//$'\n'/%0A}
}
command_property() {
  local s=$(command_data $1)
  s=${s//:/%3A}
  print -rn -- ${s//,/%2C}
}

# annotate <error|warning|notice> <title> <message> [file] -- in GitHub Actions, add an
# annotation to the run page, attached to <file> when given.
annotate() {
  ((gha)) || return 0
  local props="title=$(command_property ${2//\`/})"
  [[ -n ${4-} ]] && props="file=$(command_property $4),$props"
  print -r -- "::$1 $props::$(command_data ${3//\`/})"
}

# area <name> [file] -- name the checks that follow in the summary table; their failures are
# annotated on <file>.
area() {
  report_area=$1
  report_file=${2-}
}

# alert <TYPE> <line>... -- print a GitHub alert: NOTE, TIP, IMPORTANT, WARNING, or CAUTION.
alert() {
  print -r -- "> [!$1]"
  shift
  print -rl -- "> "${^@}
}

# ok <check> -- record a passing check.
# Pre-increment: `((pass++))` is false while pass is 0, which would run a `|| bad` branch.
ok() {
  print -r -- "$report_pass $1"
  report_rows+=("| Passed | $report_area | ${1//|/\\|} |")
  ((++pass))
}

# bad <check> [detail-line]... -- record a failing check and what went wrong.
bad() {
  local check=$1
  shift
  local -a details=("${@:-no details}")
  print -r -- "$report_fail $check"
  print -rl -- "     | "${^details}
  report_rows+=("| **Failed** | $report_area | ${check//|/\\|} |")
  report_failures+=("$(alert CAUTION "**Failed: $check**" "" "~~~text" "${(@)details}" "~~~")")
  annotate error "$report_area: $check" "${(F)details[1,5]}" $report_file
  ((++fail))
}

# check <check> <status> [detail-line]... -- ok when <status> is 0, else bad with the details:
#   [[ $out == *done* ]]; check "it finishes" $? "$out"
check() {
  local name=$1 st=$2
  shift 2
  if ((st == 0)); then ok $name; else bad $name "$@"; fi
}

# report <title> [markdown-block]... -- print the totals and append the job summary: the
# outcome, the given blocks (context alerts, tables), every check, then each failure.
# Blocks are separated by blank lines, which keep a table out of the alert above it. Returns 1
# if any check failed.
report() {
  local title=$1 block
  shift
  print -r -- "---- $pass passed, $fail failed"
  ((fail)) || annotate notice $title "All $pass checks passed."
  if [[ -n ${GITHUB_STEP_SUMMARY-} ]]; then
    {
      print -rl -- "## $title" ""
      if ((fail)); then
        alert CAUTION "**$fail of $((pass + fail)) checks failed.**" \
          "Each failure is listed below the table and annotated on the run."
      else
        alert TIP "**All $pass checks passed.**"
      fi
      print
      for block in "$@"; do print -rl -- "$block" ""; done
      print -rl -- "| Result | Area | Check |" "| --- | --- | --- |" $report_rows ""
      for block in $report_failures; do print -rl -- "$block" ""; done
    } >> $GITHUB_STEP_SUMMARY
  fi
  ((fail == 0))
}

# abort <title> <reason> -- stop before the checks ran, and say why on the run page.
abort() {
  print -u2 -r -- "${ZSH_ARGZERO:t}: $2"
  annotate error $1 "Did not run: $2"
  [[ -n ${GITHUB_STEP_SUMMARY-} ]] \
    && { print -rl -- "## $1" ""; alert CAUTION "**Did not run.** $2"; print } >> $GITHUB_STEP_SUMMARY
  exit 1
}
