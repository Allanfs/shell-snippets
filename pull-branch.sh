#!/bin/bash

# Uso: partindo de uma branch de trabalho
# o comando vai para a branch $1 faz pull
# e retorna para a branch de trabalho.
#
# Prametros:
# $1 nome da branch que sera feito o pull

# cores de texto
NOCOLOR='\033[0m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
WHITE='\033[1;37m'

base_branch=`git branch --show-current`
echo -e "$DARKGRAY"
git checkout $1
git pull
git checkout $base_branch

echo -e "${WHITE}\nconcluido, de volta para a branch ${base_branch}"
