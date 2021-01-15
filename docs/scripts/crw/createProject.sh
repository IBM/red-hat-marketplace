#!/bin/bash

#login as admin prior to running this script.
#eg: ./createProejct.sh crw-test

echo "Creating project: $1" 

oc adm new-project $1