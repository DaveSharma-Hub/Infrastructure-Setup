#!/bin/bash

SCRIPT_TO_RUN=$1
ARGUMENTS=(5 5 5 5 5)
MAX_PARALLEL_RUNNERS=$3

DEFAULT_PARALLEL_RUNNERS=4

if [ -z $SCRIPT_TO_RUN ];then
    echo "Please provide script to run"
    exit 1
fi

if [ ! -f $SCRIPT_TO_RUN ];then
    echo "File not found"
    exit 1
fi

#Set default max parallel runners
if [ -z $MAX_PARALLEL_RUNNERS ];then
    echo "No max parallel runners option provided - defaulting to 4"
    MAX_PARALLEL_RUNNERS=$DEFAULT_PARALLEL_RUNNERS
fi

function checkCondition(){
    INDEX=$1
    TOTAL_LENGTH=$2
    SUB_LENGTH=$3
    if [ "$INDEX" -lt "$SUB_LENGTH" ] &&  [ "$INDEX" -lt "$TOTAL_LENGTH" ]; then
        echo "TRUE"
    else
        echo "FALSE"
    fi
}

function runJob(){
    INDEX=$1
    bash "$SCRIPT_TO_RUN" "${ARGUMENTS[$INDEX]}" 
}

function mainRunner(){
    LEN=${#ARGUMENTS[@]}
    for ((i=0; i<$LEN;)); do
        echo "$i"
        SUB_LENGTH=$((i+MAX_PARALLEL_RUNNERS))
        while [ "$(checkCondition $i $LEN $SUB_LENGTH)" == "TRUE" ]; do 
            runJob "$i" &
            ((i++))
        done
        wait
    done

}

mainRunner
echo "All jobs completed"