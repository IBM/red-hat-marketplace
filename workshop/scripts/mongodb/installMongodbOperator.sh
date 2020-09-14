#!/bin/sh

PROJECT=mongodb-trial

echo "Creating project for MongoDB install" 
oc new-project $PROJECT

echo "Creating Operator group..." 
oc apply -f mongodbOperatorGroup.yaml

echo "Creating subscription..." 
oc apply -f mongodbSubscription.yaml

echo "Mongodb install initiated." 
echo "Run the commands below to ensure the " 
oc describe sub mongodb-enterprise-advanced-ibm-rhmp -n $PROJECT | grep -A5 Conditions
