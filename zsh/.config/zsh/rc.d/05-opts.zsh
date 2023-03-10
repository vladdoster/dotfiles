#!/usr/bin/env zsh
##
# Shell options that don't fit in any other file.
#
# Set these after sourcing plugins, because those might set options, too.
#
# don't let > silently overwrite files. to overwrite, use >! instead.
setopt NO_CLOBBER
# treat comments pasted into the command line as comments, not code.
setopt INTERACTIVE_COMMENTS
# don't treat non-executable files in your $path as commands. this makes sure
# they don't show up as command completions. settinig this option can impact
# performance on older systems, but should not be a problem on modern ones.
setopt HASH_EXECUTABLES_ONLY
# enable ** and *** as shortcuts for **/* and ***/*, respectively.
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Recursive-Globbing
setopt GLOB_STAR_SHORT
# sort numbers numerically, not lexicographically.
setopt NUMERIC_GLOB_SORT
