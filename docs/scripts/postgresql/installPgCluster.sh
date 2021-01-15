#!/bin/sh

PROJECT=postgresql-trial

echo "Remove secrets..." 
oc delete secret pg-admin -n $PROJECT


echo "Creating secret ops-manager-admin ..." 
oc create secret generic pg-admin  \
--from-literal=Username="rhmadmin" \
--from-literal=Password="JumpstartWithM@rketp1ace" \
--from-literal=FirstName="RHM" \
--from-literal=LastName="Admin" -n $PROJECT

echo "Creating an instance of CRD Pgcluster" 
#curl -sL https://raw.githubusercontent.com/IBM/red-hat-marketplace/master/workshop/scripts/mongodb/createMongdbOpsManager.yaml | oc apply -f -

#sleep 2
#echo "Creating an instance based on CRD MongoDBOpsManager" 
#echo "Check the status of deploy with this command: oc describe om ops-manager | grep -A5 Status"
#oc describe om ops-manager | grep -A5 Status
  
#Run the script
#source <(curl -s https://raw.githubusercontent.com/IBM/red-hat-marketplace/master/workshop/scripts/mongodb/installMongodbOpsManager.sh)