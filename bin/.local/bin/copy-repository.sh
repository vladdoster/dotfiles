#!/usr/bin/env bash

set -eo pipefail # Let pipe command return possible e.g., stalled network.

NO_ARGS=0
E_OPTERROR=85
TMP=${TMPDIR:-/tmp}/${0##*/}.$$ # Store refined download list.
printf -- "\n--- create tmp dir %s" "$TMP"

trap "{
rm -f $TMP 2>/dev/null
}" EXIT # Clear temporary file on exit.

mirror() {
    printf -- "--- Cloning %s" "$OPTARG"
    git clone --bare "$OPTARG" "$TMP"
    printf -- "\n--- Cloned repo into %s" "$OPTARG"
    pushd "$TMP"

    REPO_NAME=$(basename "$(git remote get-url origin)")
    REPO_URL="https://github.com/vladdoster/$REPO_NAME"

    printf -- "\n--- Cloned %s " $REPO_NAME
    git push --mirror https://github.com/vladdoster/"$REPO_NAME"
    printf -- "\n--- Pushed new to: %s" $REPO_URL
}

if [[ $# -eq $NO_ARGS ]]; then # Script invoked with no command-line args?
    echo "Usage: $(basename $0) options (-hmn)"
    exit $E_OPTERROR # Exit and explain usage.
fi
while getopts ":h:m:n:" Option; do
    case $Option in
        h)
            usage
            ;;
        m) # mirror repository
            printf -- "\n--- mirroring %s" "$OPTARG"
            mirror
            ;;
        n) # new repository (no history)
            printf -- "\n--- creating new repository from %s" "$OPTARG"
            ;;
    esac
done
shift $((OPTIND - 1)) # Move argument pointer to next.
