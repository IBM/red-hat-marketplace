#!/bin/sh

PROJECT=mongodb-trial

#Create configmap (project and organizatid created with default values)
echo "Creating a config map " 
oc create configmap mongodb-cm --from-literal="baseUrl=http://ops-manager-svc.mongodb-trial.svc.cluster.local:8080"

echo "Creating a config map " 
curl -sL https://raw.githubusercontent.com/IBM/red-hat-marketplace/master/workshop/scripts/mongodb/createMongodb.yaml | oc apply -f -

oc describe  Mongodb rhm-mongodb-replica-set

#MongoDB Endpoint format
#<mongodb-service-name>.<k8s-namespace>.svc.<cluster-name>
#mongodb+srv://rhm-mongodb-replica-set-svc.mongodb-trail.svc.cluster.local
#mongodb://rhm-mongodb-replica-set-svc.mongodb-trial.svc.cluster.local:27017/myguestbook

#To run this script
#source <(curl -s https://raw.githubusercontent.com/IBM/red-hat-marketplace/master/workshop/scripts/mongodb/installMongodb.sh)
