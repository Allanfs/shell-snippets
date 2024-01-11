#!/bin/bash

while "$@"; do : 
    go clean -testcache
    sleep 60 
done