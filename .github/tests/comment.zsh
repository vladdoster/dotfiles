#!/usr/bin/env zsh
# Put one job's result in the pull request's sticky comment. Run in GitHub Actions:
#   zsh .github/tests/comment.zsh <key> <title> <outcome> [results-file]
# The results file holds the job summary that report.zsh wrote (default: $RUNNER_TEMP/results.md).
# Without one, the section shows <title> and <outcome>, a step outcome such as cancelled. Needs
# gh, GH_TOKEN, PR (the pull request number), and the default GITHUB_* variables. Each job owns
# the section between its <key> markers. An update replaces the whole comment, so two jobs must
# not run this at the same time.
emulate -L zsh

readonly key=$1 results=${4:-$RUNNER_TEMP/results.md}
readonly api=repos/$GITHUB_REPOSITORY/issues
readonly marker='<!-- install-results -->' start="<!-- $key -->" end="<!-- /$key -->"

local summary="## $2"$'\n\n'"No results were written. The step outcome was \`$3\`."
[[ -s $results ]] && summary=$(< $results)
# GitHub rejects a comment over 65536 characters. Three sections of 20000 fit.
summary=${summary[1,20000]}

local section="$start
$summary

[Run #$GITHUB_RUN_NUMBER]($GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID)
$end"

local id body
id=$(gh api --paginate $api/$PR/comments \
  --jq ".[] | select(.body | startswith(\"$marker\")) | .id") || exit 1
id=${id%%$'\n'*}
local -a target=($api/$PR/comments)
if [[ -n $id ]]; then
  body=$(gh api $api/comments/$id --jq .body) || exit 1
  target=(-X PATCH $api/comments/$id)
else
  body=$marker
fi

if [[ $body == *$start*$end* ]]; then
  body=${body/$start*$end/$section}
else
  body+=$'\n\n'$section
fi

readonly out=$(mktemp)
print -r -- $body > $out
gh api --silent $target -F body=@$out
