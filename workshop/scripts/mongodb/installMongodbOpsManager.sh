#!/bin/sh

PROJECT=mongodb-trial

echo "Creating secret ops-manager-admin ..." 
oc create secret generic ops-manager-admin  \
--from-literal=Username="rhmadmin@ibm.com" \
--from-literal=Password="Jumpst@rtW1thM@rketp1ace" \
--from-literal=FirstName="RHM" \
--from-literal=LastName="Admin" -n $PROJECT

echo "Creating an instance based on CRD MongoDBOpsManager" 
curl -sL https://raw.githubusercontent.com/IBM/red-hat-marketplace/master/workshop/scripts/mongodb/createMongdbOpsManager.yaml | oc apply -f -

sleep 2
oc describe MongoDBOpsManager ops-manager