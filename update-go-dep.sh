#!/bin/bash

# Atualiza uma dependencia do go.mod e faz um commit dessa atualização
# Parametros:
# $1 nome da dependencia

DEP_NAME=$1

REPO=`echo ${DEP_NAME} | cut -d "/" -f 3`

tmp=`mktemp`

go get $DEP_NAME 2>&1 | tee $tmp

OUTPUT=`grep $DEP_NAME $tmp`

TO_VERSION=`echo $OUTPUT | grep $DEP_NAME | cut -d "=" -f 2  | cut -d "v" -f 2`

echo ">> Informe o ID da task: "
read TASK

echo "PR da versão ${TO_VERSION}?"
read PR

commit_msg="${TASK}: update ${REPO} to v${TO_VERSION}"


if [[ -n "$PR" ]]; then
    commit_msg=$commit_msg$'\n\n'$PR
fi


git add go.mod
git add go.sum

git commit -m "$commit_msg"
