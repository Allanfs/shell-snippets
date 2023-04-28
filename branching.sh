#!/bin/bash

generate_branch_name() {
    bname=`echo $1 | tr [:lower:] [:upper:]`
    echo ${bname}--`git branch --show-current`
}

# $1 : branch de destino (dev, hml, stg)
checkout_to() {
    git branch --show-current | read CURRENT_BRANCH
    NEXT_BRANCH=`generate_branch_name $1`
    git checkout $NEXT_BRANCH
    if [[ $? -eq 1 ]]; then
        git checkout -b $NEXT_BRANCH
    fi
    store_previous_branch $CURRENT_BRANCH
}

checkout_back() {
    git branch --show-current | read CURRENT
    branch_back=`get_previous_branch`
    store_previous_branch $CURRENT
    git checkout $branch_back
}

get_previous_branch() {
    repo=$TMP_FILE `_get_repo_name`
    cat $repo
}
TMP_FILE="/tmp/branching-previous-branch"
store_previous_branch() {
    repo=$TMP_FILE `_get_repo_name`
    echo $1 > $repo
}

# $1 : branch que será integrada (dev, hml, stg)
merge_to() {
    CURRENT_BRANCH=`git branch --show-current`

    checkout_to $1

    git merge $CURRENT_BRANCH

    checkout_back
}

push() {
    BRANCH_TO_PUSH=$(generate_branch_name $1)

    echo $BRANCH_TO_PUSH
    git push -u origin $BRANCH_TO_PUSH
}

_get_repo_name() {
    basename `git rev-parse --show-toplevel`
}