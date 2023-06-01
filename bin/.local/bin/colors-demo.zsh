#!/usr/bin/env zsh
#
# colors-demo.zsh
#

emulate -L csh
# background
for clbg in {40..47} {100..107} 49 ; do
	# foreground
	for clfg in {30..37} {90..97} 39 ; do
		# formatting
		for attr in 0 1 2 4 5 7 ; do
			# print the result
			echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
		done
		echo 
	done
done

exit 0

# vim: set expandtab filetype=zsh shiftwidth=4 softtabstop=4 tabstop=4:
