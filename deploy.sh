#!/bin/bash
git checkout develop
git pull origin develop

# Commit and push to the deploy branch
cd deploy-branch/
git add .
git commit -m "Deploy latest build"
git push origin deploy

# Return to the main project directory
cd -

read -n1 -r -p "Press any key to close..." key