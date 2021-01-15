#!/bin/bash
#------------------------------------------------------------------------------------------
# Script:  uninstall-rhm-operator
#------------------------------------------------------------------------------------------
# Red Hat Marketplace tools - Uninstall Red Hat Marketplace Operator
#------------------------------------------------------------------------------------------
# Copyright (c) 2020, International Business Machines. All Rights Reserved.
#------------------------------------------------------------------------------------------

# function implementations can be found in https://marketplace.redhat.com/provisioning/v1/scripts/rhm-script-functions
source /dev/stdin <<<"$(curl -s https://marketplace.redhat.com/provisioning/v1/scripts/rhm-script-functions)"

function main () {

  echo  "=================================================================================="
  echo  "                  [INFO] Uninstall Red Hat Marketplace Operator...                "
  echo  "=================================================================================="

  namespace="openshift-redhat-marketplace"

  displayStepTitle 1 "Deleting Marketplace Config..."
  deleteconfigmsg=$(oc delete MarketplaceConfig marketplaceconfig -n "$namespace" 2>&1 )
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    echoYellow "[WARN]: ${deleteconfigmsg}"
  else
    echo "${deleteconfigmsg}"
  fi 

  printNewLines 1

  displayStepTitle 2 "Deleting Red Hat Marketplace Operator Secret..."
  deletesecretmsg=$(oc delete secret rhm-operator-secret -n "$namespace" 2>&1 )
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    echoYellow "[WARN]: ${deletesecretmsg}"
  else
    echo "${deletesecretmsg}"
  fi 

  printNewLines 1

  displayStepTitle 3 "Deleting Razee Deployment..."
  echo "NOTE: This could take several minutes to complete..."
  deleterazeedeploymsg=$(oc delete RazeeDeployment rhm-marketplaceconfig-razeedeployment -n "$namespace" 2>&1 )
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    echoYellow "[WARN]: ${deleterazeedeploymsg}"
  else
    echo "${deleterazeedeploymsg}"
  fi 

  printNewLines 1

  displayStepTitle 4 "Deleting Red Hat Marketplace Operator Subscription..."
  deletesubmsg=$(oc delete subscription redhat-marketplace-operator -n "$namespace" 2>&1 )
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    echoRed "[ERROR]: ${deletesubmsg}"
    echoRed "Uninstall Red Hat Marketplace Operator failed"
    exit $RETVAL
  else
    echo "${deletesubmsg}"
  fi 

  printNewLines 1

  displayStepTitle 5 "Deleting Red Hat Marketplace CSV..."
  csvname=$(oc get csv -n "$namespace" --ignore-not-found | awk '$1 ~ /redhat-marketplace-operator/ { print }' | awk '{print $1}'  2>&1 )
  if [ "$csvname" = "" ]; then
    echo "[WARN]: CSV not found"
  else
    csvdelete=$(oc delete csv "$csvname" -n "$namespace"  2>&1 )
    RETVAL=$?
    if [ $RETVAL -gt 0 ]; then
      echoRed "[ERROR]: ${csvdelete}"
      echoRed "Uninstall Red Hat Marketplace Operator failed"
      exit $RETVAL
    else
      echo "${csvdelete}"
    fi 
  fi 

  printNewLines 1
  echoGreen "Red Hat Marketplace Operator successfully uninstalled"

}

checkOCInstalled

main