#!/bin/bash

#login as admin prior to running this script.
#eg: ./installCRW.sh crw-test

echo "Installing CRW for user $1" 

echo "Logged in as..."
oc whoami

namespace="crw-user-$1"

echo "1: Creating CRW namespace $namespace"
sed "s/#REPLACE-NS#/$namespace/g" crw-namespace-template.yaml | oc apply -f -

#sed "s/REPLACE-NS/$namespace/g" crw-namespace-template.yaml > crw-namespace-run.yaml
#oc apply -f crw-namespace-run.yaml
#rm crw-namespace-run.yaml

echo "2: Creating CRW operatorgroup for $namespace"
sed "s/#REPLACE-NS#/$namespace/g" crw-operatorgroup-template.yaml | oc apply -f -

echo "3: Creating CRW subscription for $namespace"
sed "s/#REPLACE-NS#/$namespace/g" crw-subscription-template.yaml | oc apply -f -

echo "4: Creating CRW Che cluster for $namespace"
sed "s/#REPLACE-NS#/$namespace/g" crw-create-che-cluster-template.yaml | oc apply -f -

echo "CRW install complete for $namespace"
