#!/bin/bash

echo "---Cloning old repo"
git clone "${1}" "old-repository"
echo "---Working directory\n$(ls)"

cd "old-repository" \
  && [[ -d ".git" ]] && rm -rf ".git/" || exit 1 \
  && echo "---Current directory: $(PWD)\n$(ls)" \
  && git init \
  && git add .\
  && git commit -m "Initial commit" \
  && git branch -M master \
  && git remote add origin "https://github.com/vladdoster/${2}.git" \
  && git push -u origin master \
  && echo "---Repository name: ${repo_name}" \

rm -rf old-repository.git
