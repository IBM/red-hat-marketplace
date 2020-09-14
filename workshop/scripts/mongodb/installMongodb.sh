#!/bin/sh

PROJECT=mongodb-trial

oc create secret generic ops-manager-admin  \
--from-literal=Username="rhmadmin@ibm.com" \
--from-literal=Password="Jumpst@rtW1thM@rketp1ace" \
--from-literal=FirstName="RHM" \
--from-literal=LastName="Admin" -n $PROJECT


#Create configmap (project and organizatid created with default values)
oc create configmap mongodb-cm --from-literal="baseUrl=http://ops-manager-svc.mongodb-trial.svc.cluster.local:8080"

oc describe  Mongodb rhm-mongodb-replica-set

#<mongodb-service-name>.<k8s-namespace>.svc.<cluster-name>
#mongodb+srv://rhm-mongodb-replica-set-svc.mongodb-trail.svc.cluster.local
#crw - rojanjose@gmail/rhmjumpstart
#mongodb://rhm-mongodb-replica-set-svc.mongodb-trial.svc.cluster.local:27017/myguestbook