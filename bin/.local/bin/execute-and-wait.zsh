#!/usr/bin/env zsh
#
# execute-and-wait.zsh
#

CHECK_SYMBOL='+'
X_SYMBOL='X'

#
# Run the command passed as 1st argument and shows the spinner until this is done
#
# @param String $1 the command to run
# @param String $2 the title to show next the spinner
# @param var $3 the variable containing the return code
#
local __resultvar=$3

eval $1 > /tmp/execute-and-wait.log 2>&1 &
pid=$!
delay=0.08
frames=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)

echo "$pid" > "/tmp/.spinner.pid"

# Hide the cursor, it looks ugly :D
tput civis
index=0
framesCount=${#frames[@]}
while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
  lim=$(tput cols)
   if [[ $index -eq 0 ]]; then
    index+=1
  fi
  printf ' %.0s' {1..$lim}
  echo -n "\r"
  builtin print -f "${YELLOW}${frames[$index]}${NC} ${GREEN}$2${NC}"

  index=$(( $(( $index + 1 )) % $(( ${#frames} + 1 )) ))
  # Calculate the screen width
  # Clear the line and move the cursor to the start
  sleep $delay
    # Return to the beginning of the line
  echo -n "\r"
done

#
# Wait the command to be finished, this is needed to capture its exit status
#
wait $!
exitCode=$?

if [ "$exitCode" -eq "0" ]; then
  printf "${CHECK_SYMBOL} ${2}                                                                \b\n"
else
  printf "${X_SYMBOL} ${2}                                                                \b\n"
fi

# Restore the cursor
tput cnorm

return $exitCode

# vim: set expandtab filetype=zsh shiftwidth=4 softtabstop=4 tabstop=4:
