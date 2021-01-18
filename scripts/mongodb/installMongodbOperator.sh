#!/bin/sh

PROJECT=mongodb-trial

echo "Creating project for MongoDB install" 
oc new-project $PROJECT

echo "Creating Operator group..." 
curl -sL https://raw.githubusercontent.com/IBM/red-hat-marketplace/master/workshop/scripts/mongodb/mongodbOperatorGroup.yaml | oc apply -f -
#oc apply -f mongodbOperatorGroup.yaml

echo "Creating subscription..." 
curl -sL https://raw.githubusercontent.com/IBM/red-hat-marketplace/master/workshop/scripts/mongodb/mongodbSubscription.yaml | oc apply -f -
#oc apply -f mongodbSubscription.yaml

echo "Mongodb install initiated." 
echo "Run the commands below to ensure the status shows ... " 
echo "oc describe sub mongodb-enterprise-advanced-ibm-rhmp -n $PROJECT | grep -A5 Conditions"
oc describe sub mongodb-enterprise-advanced-ibm-rhmp -n $PROJECT | grep -A5 Conditions

#To run this script
#source <(curl -s https://raw.githubusercontent.com/IBM/red-hat-marketplace/master/workshop/scripts/mongodb/installMongodbOperator.sh)
