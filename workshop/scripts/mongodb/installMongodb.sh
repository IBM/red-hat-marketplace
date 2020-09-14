#!/bin/sh

PROJECT=mongodb-trial


echo "Creating an instance based on CRD MongoDBOpsManager" 
curl -sL https://raw.githubusercontent.com/IBM/red-hat-marketplace/master/workshop/scripts/mongodb/createMongdbOpsManager.yaml | oc apply -f -

sleep 2
oc describe MongoDBOpsManager ops-manager


#Create configmap (project and organizatid created with default values)
oc create configmap mongodb-cm --from-literal="baseUrl=http://ops-manager-svc.mongodb-trial.svc.cluster.local:8080"

oc describe  Mongodb rhm-mongodb-replica-set

#<mongodb-service-name>.<k8s-namespace>.svc.<cluster-name>
#mongodb+srv://rhm-mongodb-replica-set-svc.mongodb-trail.svc.cluster.local
#crw - rojanjose@gmail/rhmjumpstart
#mongodb://rhm-mongodb-replica-set-svc.mongodb-trial.svc.cluster.local:27017/myguestbook