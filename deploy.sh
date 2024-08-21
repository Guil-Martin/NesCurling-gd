#!/bin/bash

# Copy the export folder to the deploy worktree
cp -r export/* ../deploy-branch/

# Commit and push to the deploy branch
cd ../deploy-branch/
git add .
git commit -m "Deploy latest build"
git push origin deploy

# Return to the main project directory
cd -