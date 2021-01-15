#!/bin/bash

# Create Project for CRW

echo "1: Creating CRW project .."
./createProject.sh crw-test


echo "2: Creating CRW operator group .."
oc apply -f crw-operatorgroup.yaml

echo "3: Creating CRW subscription .."
oc apply -f crw-subscription.yaml
