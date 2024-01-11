#!/bin/bash

# git diff --name-only | wc -l | grep -q 0 || {
#     echo "Nenhum arquivo preparado para commit."
#     echo "execute: git add <arquivo>"
#     exit 1
# }

git commit --amend --no-edit