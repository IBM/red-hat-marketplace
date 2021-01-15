#!/bin/bash
#------------------------------------------------------------------------------
# Script:  install-operator
#------------------------------------------------------------------------------
# Red Hat Marketplace tools - Install Red Hat Marketplace Operator
#------------------------------------------------------------------------------
# Copyright (c) 2020, International Business Machines. All Rights Reserved.
#------------------------------------------------------------------------------

# function implementations can be found in https://marketplace.redhat.com/provisioning/v1/scripts/rhm-script-functions
source /dev/stdin <<<"$(curl -s https://marketplace.redhat.com/provisioning/v1/scripts/rhm-script-functions)"

namespace="openshift-redhat-marketplace"
account_id=""
cluster_uuid=""
pull_secret=""
approval_strategy=""

checkOCInstalled

checkJQInstalled

checkOCCliVersion

checkOCServerVersion

checkOCClientVersion

setPullSecretDryRunValue

function main () {
  parseInputParams "$@"

  echo  "=================================================================================="
  echo  "                   [INFO] Installing Red Hat Marketplace Operator...              "
  echo  "=================================================================================="

  getInputParamsV2 "$@"
  
  checkApprovalStrategy "$approval_strategy"

  printNewLines 1

  promptToContinue "Continue with installation? [Y/n]: "

  printNewLines 1

  #step 1 Validating Namespace
  displayStepTitle 1 "Validating Namespace"
  result=$(oc get ns "$namespace"  2>&1)
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
      echo "Installing Red Hat Marketplace Operator"
  else
    result=$(oc get operatorgroup -n "$namespace" --ignore-not-found | grep -c -v redhat-marketplace-operator  2>&1)
    if [ "$result" -eq 1 ] ; then
      echoYellow "[WARN]: Detected Namespace $namespace already exists. Validating if cluster is ready for install. This can take a few minutes..."
      check_for_razee=$(checkRazeeResources "$namespace" 5 2>&1)
      if [[ $check_for_razee == *"All Razee resources created successfully."* ]]; then
        exitInstallationWithErrorMessage "[ERROR]: Cluster is already registered with Red Hat Marketplace. Please uninstall Red Hat Marketplace Operator before trying to re-register cluster with Red Hat Marketplace."
      fi
      checkClusterUnregistered "$namespace"
      promptToContinue "Cluster ready for install. Continue with installation? [Y/n]: "
    else
      exitInstallationWithErrorMessage "[ERROR]: Namespace openshift-redhat-marketplace exists with a pre-existing operator group that prevents the installation of Red Hat Marketplace Operator."
    fi
  fi

  printNewLines 1

  #step 2  Installing Red Hat Marketplace Operator
  displayStepTitle 2 "Installing the Red Hat Marketplace Operator. This might take several minutes"
  result=$(curl -s -H "Authorization: Bearer $pull_secret" https://marketplace.redhat.com/provisioning/v1/install/rhm-operator\?accountId="$account_id"\&uuid="$cluster_uuid"\&approvalStrategy="$approval_strategy" | oc apply --validate=false -f - 2>&1)
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    exitRHMOperatorInstallationOnError $RETVAL "$result"
  else
    echo "$result"
  fi
  
  #Message to approve Install Plan if approval strategy selected is Manual
  if [ "$approval_strategy" = "Manual" ] ; then
    echoYellow "[WARN]: Manual Approval Strategy requires you to approve the Install Plan from the dashboard. Go to the Installed Operators section in your OpenShift console to manually approve the installation plan and proceed with this script."
    retryCount=600
  fi

  #Checking for Cluster Service Version
  echo "Checking for Cluster Service Version"
  check_for_csv_success=$(checkClusterServiceVersionSucceeded "$retryCount" 2>&1)
  if [[ $check_for_csv_success != "Succeeded" ]]; then
     exitInstallationWithErrorMessage "[ERROR]: Cluster Service Version not succeeded"
  fi

  #Checking for Custom Resource Definition
  echo "Checking for Custom Resource Definition"
  crd_found=$(checkCustomResourceDefinition "$retryCount" 2>&1)
  if [[ $crd_found == "" ]]; then
     exitInstallationWithErrorMessage "[ERROR]: Custom Resource Definition not found"
  fi

  printNewLines 1

  #step 3 Creating Red Hat Marketplace Operator Marketplace Config custom resource
  displayStepTitle 3 "Creating Red Hat Marketplace Operator Config custom resource"
  result=$(curl -s -H "Authorization: Bearer $pull_secret" https://marketplace.redhat.com/provisioning/v1/install/rhm-operator/customresource\?accountId="$account_id"\&uuid="$cluster_uuid" | oc apply -f - 2>&1)
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    echo "[ERROR]: Red Hat Marketplace Operator custom resource not created"
    exitInstallationWithErrorMessage "[ERROR DETAIL]: $result"
  else
    echo "$result"
  fi

  printNewLines 1

  #step 4 Checking for Razee resources to be created
  displayStepTitle 4 "Checking for Razee resources to be created"
  checkRazeeResources "$namespace"

  printNewLines 1

  #step 5 Applying global pull secret
  displayStepTitle 5 "Applying global pull secret"
  updateGlobalPullSecret "$pull_secret"
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    exitInstallationWithErrorMessage "[ERROR]: Error applying global pull secret"
  else
    echo "Applying global pull secret succeeded"
  fi

  echo "Install complete, all resource created."
  echo  "=================================================================================="

  printNewLines 2

  echoGreen "Red Hat Marketplace Operator successfully installed."
  printNewLines 1
  echo "It may take a few minutes for your cluster to show up in the Marketplace console so you can install purchased software or trials."

  printNewLines 1

  echoBlue "Would you like to go back to the Red Hat Marketplace now? [Y/n]"
  read -r proceed </dev/tty
  if [[ ! $proceed || $proceed = *[^yY] ]]; then
    exit 0
  else
    echo "Opening Red Hat Marketplace in default browser..."
    open 'https://marketplace.redhat.com/en-us/workspace/clusters'   
  fi

}

main "$@"
