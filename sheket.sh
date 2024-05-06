#!/bin/bash
changes=("$@")
# Make changes to .gitignore in the current branch
for change in "${changes[@]}"; do
    echo "$change" >> .gitignore
    git add .gitignore
    git commit -m "Update .gitignore with $change"
done
all_branches=$(git branch | grep -v "$(git rev-parse --abbrev-ref HEAD)")
for branch in $all_branches; do
    git checkout $branch
    for change in "${changes[@]}"; do
    # Discard changes in .gitignore in the current working directory - reverting to last commit version
        git checkout HEAD -- .gitignore
        echo "$change" >> .gitignore
        git add .gitignore
        git commit -m "Update .gitignore with $change"
    done
done
git checkout -