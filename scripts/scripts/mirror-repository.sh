#!/bin/bash

echo "---Cloning old repo"
git clone --bare "${1}" "old-repository"
echo "---Working directory\n$(ls)"

cd "old-repository" \
    && echo "---Current directory: $(PWD)\n$(ls)" \
    && repo_name="${2}" \
    && echo "---Repository name: ${repo_name}" \
    && git push --mirror "https://github.com/vladdoster/${repo_name}"

rm -rf old-repository.git
