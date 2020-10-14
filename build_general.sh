#!/bin/bash

set -e

# check if necessary commands are available
command -v git > /dev/null 2>&1 || { echo "Git not installed."; exit 1; }

branch=`git rev-parse --abbrev-ref HEAD` #set default stage
echo -e "selected branch $branch"

# Retrieve the modified files, excluding the merge commit
merge_commit_hash=`git rev-parse --short HEAD`
build_commit_hash=`git rev-list --no-merges -n1 HEAD`

files="$(git diff-tree --no-commit-id --name-only -r $build_commit_hash)"
packages=()


# Retrieve the modified packages
for file in $files
do
    package="$(echo $file | cut -d '/' -f2)"
    if test -d packages/$package; then 
        # Retrieve the project build_priority in the package.json, default value is 50
        priority="$(cat packages/$package/package.json | grep build_priority | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g')"
        if [ -z "$priority" ]; then
            priority=50
        fi   
        packages+=($priority/$package);
    fi
done

# clean and order packages list
packages=($(echo "${packages[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
rootDir=`pwd`

# launch each package build.sh script if present
if [ "${#packages[@]}" -gt 0 ]; then

    for package in ${packages[@]}
    do
        priority="$(echo $package | cut -d '/' -f1)"
        package="$(echo $package | cut -d '/' -f2)"
        echo -e "- Building $package at version $merge_commit_hash with priority $priority"
        if [ -f $rootDir/packages/$package/build.sh ]; then
            echo -e "  build script found"
            cd $rootDir/packages/$package
            chmod ug+x build.sh
           ./build.sh $branch
        else 
           echo -e " no buid script found for package $package"  
        fi
    done
else
    echo "Nothing to build."
fi
