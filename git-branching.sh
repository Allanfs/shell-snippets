#!/bin/bash

# $1 : branch que será integrada (dev, hml, stg)
create_and_push_branch() {
    CURRENT_BRANCH=`git branch --show-current`
    NEXT_BRANCH=`_next_branch $1`

    git checkout -b $NEXT_BRANCH
    git push -u origin HEAD

    git checkout $CURRENT_BRANCH
}

################################################################################

# $1 : branch que será integrada (dev, hml, stg)
update_push_branch() {
    CURRENT_BRANCH=`git branch --show-current`
    NEXT_BRANCH=`_next_branch $1`

    git checkout $NEXT_BRANCH
    git merge $CURRENT_BRANCH
    # git push

    # git checkout $CURRENT_BRANCH
}


################################################################################

checkout_to() {
    CURRENT_BRANCH=`git branch --show-current`
    NEXT_BRANCH=`_next_branch $1`
    git checkout $NEXT_BRANCH
    if [[ $? -eq 1 ]]; then
        git checkout -b $NEXT_BRANCH
    fi

}

merge_to() {
    CURRENT_BRANCH=`git branch --show-current`
    NEXT_BRANCH=`_next_branch $1`

    git checkout $NEXT_BRANCH
    git merge $CURRENT_BRANCH
}

_next_branch() {
    bname=`echo $1 | tr [:lower:] [:upper:]`
    echo ${bname}/`git branch --show-current`
    # echo `git branch --show-current`-${1}
}

branch_back() {
    CURRENT=`git branch --show-current`
    STRLEN=$((${#CURRENT}-${#1}))
    git checkout ${CURRENT: 0:STRLEN-1}
}

branch_back_new() {
    CURRENT=`git branch --show-current`
    STRLEN=${#1}
    git checkout ${CURRENT: +STRLEN+1}
}