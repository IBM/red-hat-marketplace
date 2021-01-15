#!/bin/bash
#------------------------------------------------------------------------------
# Script:  install-rhm-operator
#------------------------------------------------------------------------------
# Red Hat Marketplace tools - Install Red Hat Marketplace Operator
#------------------------------------------------------------------------------
# Copyright (c) 2020, International Business Machines. All Rights Reserved.
#------------------------------------------------------------------------------


if ! [ -x "$(command -v oc)" ]; then
    printf "[ERROR]: Pre-requisite cli 'oc' is not installed\n"
    exit 1
fi

if ! [ -x "$(command -v jq)" ]; then
    printf "[ERROR]: Pre-requisite cli 'jq' is not installed\n"
    exit 1
fi

result=$(oc version -o json 2>&1)
RETVAL=$?
  if [ $RETVAL -gt 0 ];then
    echo "Unsupported oc cli version detected. Supported oc cli versions are 4.2 and higher."
    exit 1
  fi

 requiredVersion="^.*4\.([0-9]{2,}|[2-9]?)?(\.[0-9]+.*)*$"
 currentServerVersion="$(oc version -o json | jq .openshiftVersion)"
  if ! [[ $currentServerVersion =~ $requiredVersion ]]; then
  if [ "$currentServerVersion" = null ]; then
    echo "Unsupported OpenShift version below 4.2 detected. Supported OpenShift versions are 4.2 and higher."
  else 
    echo "Unsupported OpenShift version $currentServerVersion detected. Supported OpenShift versions are 4.2 and higher."
  fi  
    exit 1
  fi


 currentClientVersion="$(oc version -o json | jq .clientVersion.gitVersion)"
  if ! [[ $currentClientVersion =~ $requiredVersion ]]; then
  echo "Unsupported oc cli version $currentClientVersion detected. Supported oc cli versions are 4.2 and higher."
    exit 1
  fi


installFailureMessage="Install Red Hat Marketplace Operator failed"

function updateGlobalPullSecret () {

  local deployment_key="$1"

  oc create secret docker-registry entitled-registry --docker-server=registry.marketplace.redhat.com --docker-username=cp --docker-password="$deployment_key" --dry-run=true --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode > entitledregistryconfigjson
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    echo "[ERROR]: oc create secret docker-registry entitled-registry failed..."
    echo "${installFailureMessage}"
    exit $?
  fi

  oc get secret pull-secret -n openshift-config --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode > dockerconfigjson
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    echo "[ERROR]: oc get secret pull-secret failed..."
    echo "${installFailureMessage}"
    exit $?
  fi

  jq -s '.[0] * .[1]' dockerconfigjson entitledregistryconfigjson > dockerconfigjson-merged
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    echo "[ERROR]: jq -s dockerconfigjson entitledregistryconfigjson failed..."
    echo "${installFailureMessage}"
    exit $?
  fi

  result=$(oc set data secret/pull-secret -n openshift-config --from-file=.dockerconfigjson=dockerconfigjson-merged 2>&1 )
  RETVAL=$?

  if [ $RETVAL -gt 0 ]; then
    echo "[ERROR]: oc set data secret/pull-secret failed..."
    echo "[ERROR DETAIL]: $result"
    echo "${installFailureMessage}"
    exit $?
  else
    echo "$result"
  fi

  rm entitledregistryconfigjson
  rm dockerconfigjson
  rm dockerconfigjson-merged

  return 0
}

function stepLog(){
  echo "STEP $1/5: $2"
}

function main () {
  echo  "=================================================================================="
  echo  "                    [INFO] Installing Red Hat Marketplace Operator...             "
  echo  "=================================================================================="

  account_id=""
  cluster_uuid=""
  deployment_key=""
  approval_strategy="Automatic"

  if [ "$1" = "" ] ; then
    echo "Enter Account Id: "
    read -r account_id </dev/tty
  else
    account_id="$1"
  fi

  if [ "$2" = "" ] ; then
    echo "Enter Cluster UUID: "
    read -r cluster_uuid </dev/tty
  else
    cluster_uuid="$2"
  fi

  if [ "$3" = "" ] ; then
    echo "Enter Deployment Key: "
    read -r deployment_key </dev/tty
  else
    deployment_key="$3"
  fi

  if [ "$#" -lt "3" ] ; then
    echo "Enter Approval Strategy [Automatic/Manual]: "
    read -r approval_strategy </dev/tty
  else
    if [ "$#" -eq "4" ] ; then
      approval_strategy="$4"
    fi
  fi

  if [ "$approval_strategy" != "Automatic" ] && [ "$approval_strategy" != "Manual" ] ; then
      echo "Valid Approval Strategies are either Manual or Automatic."
      exit 1
  fi

  echo "Detected the following options: " 
  echo "> Account Id: $account_id"
  echo "> Cluster UUID: $cluster_uuid"
  echo "> Deployment Key: $deployment_key"
  echo "> Approval Strategy: $approval_strategy"
  echo "Continue with installation? [Y/n]: "

  read -r proceed </dev/tty
  if [[ ! $proceed || $proceed = *[^yY] ]]; then
    echo "Aborting installation of Red Hat Marketplace Operator..."
    echo "${installFailureMessage}"
    exit $?
  fi

  namespace="openshift-redhat-marketplace"
  

  #step 1 Validating Namespace
  stepLog 1 "Validating Namespace..."
  result=$(oc get ns "$namespace"  2>&1)
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
      echo "Installing Red Hat Marketplace Operator..."
  else
    result=$(oc get operatorgroup -n "$namespace" --ignore-not-found | grep -c -v redhat-marketplace-operator  2>&1)
    if [ "$result" -eq 1 ] ; then
      echo "[WARN]: Namespace $namespace already exists. Do you want to proceed? [Y/n]"
      read -r proceed </dev/tty
      if [[ ! $proceed || $proceed = *[^yY] ]]; then
        echo "Aborting installation of Red Hat Marketplace Operator..."
        echo "${installFailureMessage}"
        exit $?
      fi
    else
      echo "[ERROR]: Namespace openshift-redhat-marketplace exists with a pre-existing operator group that prevents the installation of Red Hat Marketplace Operator."
      echo "${installFailureMessage}"
      exit $?
    fi
  fi

  #step 2 Applying global pull secret
  stepLog 2 "Applying global pull secret..."
  updateGlobalPullSecret "$deployment_key"
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    echo "[ERROR]: Error applying global pull secret"
    echo "${installFailureMessage}"
    exit $?
  else
    echo "Applying global pull secret succeeded"
  fi

  #step 3  Installing Red Hat Marketplace Operator
  stepLog 3 "Installing the Red Hat Marketplace Operator. This might take several minutes..."
  result=$(curl -s -H "Authorization: Bearer $deployment_key" https://marketplace.redhat.com/provisioning/v1/install/rhm-operator\?accountId="$account_id"\&uuid="$cluster_uuid"\&approvalStrategy="$approval_strategy" | oc apply --validate=false -f - 2>&1)
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    echo "[ERROR]: Error installing Red Hat Marketplace Operator"
    if [[ $result == *"\"status\":401"* ]]; then
      echo "[ERROR DETAIL]: Ensure the deployment key is valid for the account."
    else
      echo "[ERROR DETAIL]: $result"
    fi
    echo "${installFailureMessage}"
    exit $?
  else
    echo "$result"
  fi

  retries=0
  retryCount=150
  if [ "$approval_strategy" = "Manual" ] ; then
    echo "Manual Approval Strategy requires you to approve the Install Plan from the dashboard. Go to the Installed Operators section in your OpenShift console to manually approve the installation plan and proceed with this script."
    retryCount=300
  fi
  echo "Checking for Cluster Service Version..."
  retries=0
  check_for_csv_success=$(oc get csv -n "$namespace" --ignore-not-found | awk '$1 ~ /redhat-marketplace-operator/ { print }' | awk -F' ' '{print $NF}')
  until [[ $retries -eq $retryCount || $check_for_csv_success = "Succeeded" ]]; do
      sleep 4
      check_for_csv_success=$(oc get csv -n "$namespace" --ignore-not-found | awk '$1 ~ /redhat-marketplace-operator/ { print }' | awk -F' ' '{print $NF}')
      retries=$((retries + 1))
  done
  if [[ $check_for_csv_success != "Succeeded" ]]; then
     echo "[ERROR]: Cluster Service Version not succeeded"
     echo "${installFailureMessage}"
     exit 1
  fi

  echo "Checking for Custom Resource Definition..."
  sleep 1
  retries=0
  crd_found=$(oc get crd razeedeployments.marketplace.redhat.com --ignore-not-found)
  until [[ $retries -eq $retryCount || $crd_found ]]; do
      sleep 4
      crd_found=$(oc get crd razeedeployments.marketplace.redhat.com --ignore-not-found)
      retries=$((retries + 1))
  done
  if [[ $crd_found == "" ]]; then
     echo "[ERROR]: Custom Resource Definition not found"
     echo "${installFailureMessage}"
     exit 1
  fi

  #step 4 Creating Red Hat Marketplace Operator Marketplace Config custom resource
  stepLog 4 "Creating Red Hat Marketplace Operator Config custom resource..."
  result=$(curl -s -H "Authorization: Bearer $deployment_key" https://marketplace.redhat.com/provisioning/v1/install/rhm-operator/customresource\?accountId="$account_id"\&uuid="$cluster_uuid" | oc apply -f - 2>&1)
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    echo "[ERROR]: Red Hat Marketplace Operator custom resource not created"
    echo "[ERROR DETAIL]: $result"
    echo "${installFailureMessage}"
    exit $?
  else
    echo "$result"
  fi

  #step 5 Checking for Razee resources to be created
  stepLog 5 "Checking for Razee resources to be created..."
  expectedPods=(featureflagsetld-controller managedset-controller mustachetemplate-controller remoteresource-controller remoteresources3-controller remoteresources3decrypt-controller watch-keeper)
  podsFound=0
  for element in "${expectedPods[@]}"
  do
    podname="$(oc get pods -o=name -n "$namespace" | grep "${element}")";
    retries=0
    retryCount=600
    until [[ $retries -eq $retryCount || $podname ]]; do
        sleep 2
        retries=$((retries + 1))
        podname="$(oc get pods -o=name -n "$namespace" | grep "${element}")";
    done
    if [[ $podname == "" ]]; then
        echo "Pod ${element} is not created..."
    else
        oc wait --for=condition=Ready "$podname" -n "$namespace" --timeout=2000s;
        RETVAL=$?
        if [ $RETVAL -gt 0 ]; then
          echo "Pod ${element} is not runnning yet..."
        else
          podsFound=$((podsFound + 1))
        fi
       
    fi
  done
  if [ $podsFound -lt 7 ]; then
    echo "[WARN]: One or more Razee resources listed above are not created yet. It may take a few more minutes for the pods to be created and running. If pods do not come up within a few minutes, consult the Troubleshooting documentation (https://marketplace.redhat.com/en-us/documentation/deployment-troubleshooting)."
    echo "${installFailureMessage}"
    exit 1
  else
    echo "Red Hat Marketplace Operator successfully installed"
  fi 


}

main "$@"
