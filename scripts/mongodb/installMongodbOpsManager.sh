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
echo "Creating an instance based on CRD MongoDBOpsManager" 
echo "Check the status of deploy with this command: oc describe om ops-manager | grep -A5 Status"
oc describe om ops-manager | grep -A5 Status

#Run the script
#source <(curl -s https://raw.githubusercontent.com/IBM/red-hat-marketplace/master/workshop/scripts/mongodb/installMongodbOpsManager.sh)