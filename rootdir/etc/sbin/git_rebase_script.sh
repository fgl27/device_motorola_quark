#!/bin/bash
# simple interactive rebase sh 
# Set on yours .bashrc ... alias rb='/home/user/this.sh' to call this from the terminal

echo "Rebase how many of the last commit: "
read input_variable
echo "You choose: $input_variable"

git rebase -i HEAD~$input_variable



