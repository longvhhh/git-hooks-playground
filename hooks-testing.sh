#!/usr/bin/env bash

# Before you run this script, make sure you follow these instructions
#
# create testing folder
# mkdir git-hook-test
# git init
#
# Add hooks-testing.sh file to your testing branch and chmod to executable
# cp ~/development/prepare-commit-msg .git/hooks/
# chmod +x .git/hooks/prepare-commit-msg
#
# Add hooks-testing.sh file to your testing branch and chmod to executable
# cp ~/development/hooks-testing.sh  git-hook-test/
# chmod +x hooks-testing.sh

# Go to master branch
git co master

# delete all local branches
git branch | grep -v "master" | xargs git branch -D 

# add hooks-testing.sh to git ignore
echo "hooks-testing.sh" > .gitignore
git add .
git commit -m "Added Git ignore file"

# re-initialize git with hooks
git init

# Utility to test branch and commit messages
create_branch_and_commit_and_log() {
	# $1 - argument as test case
	# $2 - argument as test branch
	echo ">>>>>>>>>>>> Test Case $1 <<<<<<<<<<<<"

	# Go to master branch
	git co master

	# create new test branch
	git co -b $2
	# create new file 
	touch test.txt
	# write something to new file
	echo "Testing" > test.txt
	# git add and commit
	git add .
	# don't crash the script, redirect the STDOUT and STDERR to /dev/null
	git commit -m "Test case $1" > /dev/null

	# in case of commit success, print the commit message, else reset
	if [ $? = 0 ] ; then
	    git log --oneline -1
	else
	    git reset --hard
	fi
}

# Test cases 
create_branch_and_commit_and_log 1 bug/WS-1234

create_branch_and_commit_and_log 2 bug/#WS-1234

create_branch_and_commit_and_log 3 task#WS-1234

create_branch_and_commit_and_log 4 taskWS-1234

create_branch_and_commit_and_log 5 task#WS-1234-#1

create_branch_and_commit_and_log 6 task-#WS-1234

create_branch_and_commit_and_log 7 task-WS-1234

create_branch_and_commit_and_log 8 refactor-xyz

create_branch_and_commit_and_log 9 refactor-1234

create_branch_and_commit_and_log 10 task-WS-1234-refactor

create_branch_and_commit_and_log 11 WS-1234

# Go to master branch
git co master
