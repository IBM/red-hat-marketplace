#!/bin/bash

account_id=""
cluster_uuid=""
pull_secret=""
approval_strategy=""
requiredVersion="^.*4\.([0-9]{2,}|[2-9]?)?(\.[0-9]+.*)*$"
version4Dot5Dot4AndHigher="^[\"]?4\.(5\.([4-9]|[1-9][0-9]+)|[6-9]|[1-9][0-9]+).*$"
dryRunValue="true"
retryCount=300
installFailureMessage="Install Red Hat Marketplace Operator failed"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
NC='\033[0m'

function echoGreen() {
  echo -e "${GREEN}$1${NC}"
}

function echoRed() {
  echo -e "${RED}$1${NC}"
}

function echoBlue() {
  echo -e "${BLUE}$1${NC}"
}

function echoYellow() {
  echo -e "${YELLOW}$1${NC}"
}

function displayStepTitle() {
  stepTitle=$(stepLog "$1" "$2")
  echoBlue "$stepTitle"
}

function stepLog() {
  echo -e "STEP $1/5: $2"
}

function printNewLines() {
  END=$1
  for (( i=1; i<="$END"; i++ )); do echo " "; done
}

function checkOCInstalled() {
  if ! [ -x "$(command -v oc)" ]; then
      echoRed "[ERROR]: Pre-requisite cli 'oc' is not installed\n"
      exit 1
  fi
}

function checkJQInstalled() {
  if ! [ -x "$(command -v jq)" ]; then
      echoRed "[ERROR] Pre-requisite cli 'jq' is not installed\n"
      exit 1
  fi
}

function checkOCCliVersion() {
  result=$(oc version -o json 2>&1)
  RETVAL=$?
  if [ $RETVAL -gt 0 ];then
    echoRed "Unsupported oc cli version detected. Supported oc cli versions are 4.2 and higher."
    exit 1
  fi
}

function checkOCServerVersion() {
  currentServerVersion="$(oc version -o json | jq .openshiftVersion)"
  if ! [[ $currentServerVersion =~ $requiredVersion ]]; then
    if [ "$currentServerVersion" = null ]; then
      echoRed "Unsupported OpenShift version below 4.2 detected. Supported OpenShift versions are 4.2 and higher."
    else
      echoRed "Unsupported OpenShift version $currentServerVersion detected. Supported OpenShift versions are 4.2 and higher."
    fi
    exit 1
  fi
}

function checkOCClientVersion() {
  currentClientVersion="$(oc version -o json | jq .clientVersion.gitVersion)"
  if ! [[ $currentClientVersion =~ $requiredVersion ]]; then
    echoRed "Unsupported oc cli version $currentClientVersion detected. Supported oc cli versions are 4.2 and higher."
    exit 1
  fi
}

function setPullSecretDryRunValue() {
  releaseClientVersion="$(oc version -o json | jq .releaseClientVersion)"
  if [[ $releaseClientVersion =~ $version4Dot5Dot4AndHigher ]]; then
    dryRunValue="client"
  fi
  echo "$dryRunValue"
}

function validateRegisteredClusteresApiCall() {
        if [[ $registered_clusters = *"{\"status\":"* ]]; then
              exitRHMOperatorInstallationOnError $RETVAL "$registered_clusters"
        fi
}

function validateClusterName() {
      registered_clusters=$(curl -s -H "Authorization: Bearer $pull_secret" https://marketplace.redhat.com/provisioning/v1/registered-clusters\?accountId="$account_id"\&name="$cluster_name"\&\$limit=1 2>&1)
      validateRegisteredClusteresApiCall "$registered_clusters"
      length=$(echo "$registered_clusters" | jq '. | length' 2>&1)
      until [ "$length" -eq "0" ]; do
          echoYellow "[WARN]: Cluster Name '$cluster_name' already exists. Please enter a unique Cluster Name."
          read -r cluster_name </dev/tty
          registered_clusters=$(curl -s -H "Authorization: Bearer $pull_secret" https://marketplace.redhat.com/provisioning/v1/registered-clusters\?accountId="$account_id"\&name="$cluster_name"\&\$limit=1 2>&1)
          validateRegisteredClusteresApiCall "$registered_clusters"
          length=$(echo "$registered_clusters" | jq '. | length' 2>&1)
      done
      cluster_uuid=$cluster_name
}

function displayHelp() {
  echoYellow "Usage: install-operator.sh [-i account_id] [-p pull_secret] [-a approval_strategy] [-c cluster_name]"
  echo "Install the Red Hat Marketplace operator on the cluster."
  echo "  -i  Red Hat Marketplace account ID"
  echo "  -p  pull secret"
  echo "  -a  approval strategy [Automatic or Manual], defaults to Automatic if not specified."
  echo "  -c  optional friendly name for the cluster, defaults to an auto-generated UUID if not specified."
  exit 0
}

function parseInputParams() {
  while getopts ":i:p:a:c:h" option
  do 
  case "${option}" 
  in 
  i) account_id=${OPTARG};;
  p) pull_secret=${OPTARG};;
  a) approval_strategy=${OPTARG};; 
  c) cluster_name=${OPTARG};;
  h) displayHelp;;
  *) echo "Invalid option -${OPTARG}" >&2;;
  esac 
  done 
}

function getInputParamsV2() {
  cluster_uuid=$(uuidgen)
  
  if [ "$#" -gt "8" ]; then 
    exitInstallationWithErrorMessage "[ERROR] Usage: install-operator.sh [-i account_id] [-p pull_secret] [-a approval_strategy] [-c cluster_name]"
  fi

  if [ "$account_id" = "" ] ; then
    echoBlue "Enter Account Id: "
    read -r account_id </dev/tty
  fi

  if [ "$pull_secret" = "" ] ; then
    echoBlue "Enter Pull Secret: "
    read -r pull_secret </dev/tty
  fi

  if [ "$approval_strategy" = "" ]; then
    approval_strategy="Automatic"
    echoBlue "Marketplace Operator Approval strategy is set to Automatic. Would you like to switch to Manual? [y/N]:"
    read -r approval_strategy_switch </dev/tty
    if [[ "$approval_strategy_switch" =~ ^([yY])$ ]]; then
        approval_strategy="Manual"
        echo "Marketplace Operator Approval strategy set to Manual."
    fi
  fi

  if [ "$cluster_name" = "" ]; then
    echo "> Cluster Name: $cluster_uuid"
    echoBlue "Edit cluster name for easy reference in Red Hat Marketplace? [Y/n]"
    proceed=""
    read -r proceed </dev/tty
    if [[ "$proceed" =~ ^([yY])$ ]]; then
      echoBlue "Enter Cluster Name: "
      read -r cluster_name </dev/tty
      validateClusterName "$cluster_name"
     fi
   else
      validateClusterName "$cluster_name"
   fi

  printNewLines 1

  echoBlue "Detected the following options: "
  echo "> Account Id: $account_id"
  echo "> Cluster Name: $cluster_uuid"
  echo "> Pull Secret: $pull_secret"
  echo "> Marketplace Operator Approval Strategy: $approval_strategy"
  echo "Continue with installation? [Y/n]: "
}

function getInputParams() {
  if [ "$1" = "" ] ; then
    echoBlue "Enter Account Id: "
    read -r account_id </dev/tty
  else
    account_id="$1"
  fi

  if [ "$2" = "" ] ; then
    echoBlue "Enter Cluster UUID: "
    read -r cluster_uuid </dev/tty
  else
    cluster_uuid="$2"
  fi

  if [ "$3" = "" ] ; then
    echoBlue "Enter Pull Secret: "
    read -r pull_secret </dev/tty
  else
    pull_secret="$3"
  fi

  if [ "$#" -lt "3" ] ; then
    echoBlue "Enter Approval Strategy [Automatic/Manual]: "
    read -r approval_strategy </dev/tty
  else
    if [ "$#" -eq "4" ] ; then
      approval_strategy="$4"
    fi
  fi

  printNewLines 1

  echoBlue "Detected the following options: "
  echo "> Account Id: $account_id"
  echo "> Cluster UUID: $cluster_uuid"
  echo "> Pull Secret: $pull_secret"
  echo "> Approval Strategy: $approval_strategy"
}

function checkApprovalStrategy() {
  approval_strategy=$1
  if [ "$approval_strategy" != "Automatic" ] && [ "$approval_strategy" != "Manual" ] ; then
    exitInstallationWithErrorMessage "[ERROR]: Valid Approval Strategies are either Manual or Automatic."
  fi
}

function promptToContinue() {
  if [ "$#" -eq "2" ] ; then
      echoYellow "$1"
  else
    echoBlue "$1"
  fi
  read -r proceed </dev/tty
  if [[ ! $proceed || $proceed = *[^yY] ]]; then
    exitInstallationWithErrorMessage "Aborting installation of Red Hat Marketplace Operator..."
  fi
}

function exitInstallationWithErrorMessage() {
  echoRed "$1"
  echoRed "${installFailureMessage}"
  exit 1
}

function exitRHMOperatorInstallationOnError() {
  exitCode=$1
  result=$2
  echoRed "[ERROR]: Error installing Red Hat Marketplace Operator"
  if [[ $result == *"\"status\":401"* ]]; then
    echoRed "[ERROR DETAIL]: Ensure the pull secret is valid for the account."
  else
    echoRed "[ERROR DETAIL]: $result"
  fi
  echoRed "${installFailureMessage}"
  exit "$exitCode"
}

function checkClusterServiceVersionSucceeded() {
  if [ "$#" -eq "1" ] ; then
    retryCount=$1
  fi
  retries=0
  check_for_csv_success=$(oc get csv -n "$namespace" --ignore-not-found | awk '$1 ~ /redhat-marketplace-operator/ { print }' | awk -F' ' '{print $NF}')
  until [[ $retries -eq $retryCount || $check_for_csv_success = "Succeeded" ]]; do
      sleep 2
      check_for_csv_success=$(oc get csv -n "$namespace" --ignore-not-found | awk '$1 ~ /redhat-marketplace-operator/ { print }' | awk -F' ' '{print $NF}')
      retries=$((retries + 1))
  done
  echo "$check_for_csv_success"
}

function checkCustomResourceDefinition() {
  if [ "$#" -eq "1" ] ; then
    retryCount=$1
  fi
  sleep 1
  retries=0
  crd_found=$(oc get crd razeedeployments.marketplace.redhat.com --ignore-not-found)
  until [[ $retries -eq $retryCount || $crd_found ]]; do
      sleep 2
      crd_found=$(oc get crd razeedeployments.marketplace.redhat.com --ignore-not-found)
      retries=$((retries + 1))
  done
  echo "$crd_found"
}

function checkRazeeResources() {
  namespace=$1

  expectedPods=(watch-keeper)

  if [ "$#" -eq "2" ] ; then
    retryCount=$2
  else
    retryCount=600
  fi

  podsFound=0

  for element in "${expectedPods[@]}"
  do
    podname="$(oc get pods -o=name -n "$namespace" | grep "${element}")";
    retries=0
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
          echo "Pod ${element} is not running yet..."
        else
          podsFound=$((podsFound + 1))
        fi

    fi
  done

  if [ $podsFound -lt 1 ]; then
    echoYellow "[WARN]: One or more Razee resources listed above are not created yet. It may take a few more minutes for the pods to be created and running. If pods do not come up within a few minutes, consult the Troubleshooting documentation (https://marketplace.redhat.com/en-us/documentation/deployment-troubleshooting)."
    echoYellow "${installFailureMessage}"
  else
    echo "All Razee resources created successfully."
  fi
}

function checkClusterUnregistered() {
  namespace=$1
  cluster_id=$(oc get ns "$namespace" -o custom-columns=":metadata.uid" | awk 'NF' )
  registered_clusters=$(curl -s -H "Authorization: Bearer $pull_secret" https://marketplace.redhat.com/provisioning/v1/registered-clusters\?accountId="$account_id"\&razee.clusterId="$cluster_id" 2>&1)
  validateRegisteredClusteresApiCall "$registered_clusters"
  length=$(echo "$registered_clusters" | jq '. | length' 2>&1)
  if [ "$length" -ne "0" ]; then
    exitInstallationWithErrorMessage "[ERROR]: Cluster is already registered with Red Hat Marketplace. Please unregister the cluster in Red Hat Marketplace before trying to re-register cluster."
  fi
}

function updateGlobalPullSecret() {
  local pull_secret="$1"
  local registry_server_str="registry.marketplace.redhat.com,cp.icr.io"
  IFS=',' read -ra registry_servers <<< "$registry_server_str"


  for registry_server in "${registry_servers[@]}"
  do
    oc create secret docker-registry entitled-registry --docker-server="$registry_server" --docker-username=cp --docker-password="$pull_secret" --dry-run="$dryRunValue" --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode > "$registry_server"
    RETVAL=$?
    if [ $RETVAL -gt 0 ]; then
      exitInstallationWithErrorMessage "[ERROR]: oc create secret docker-registry entitled-registry failed for $registry_server ..."
    fi

    if [[ "$registry_server" != "${registry_servers[0]}" ]]; then
          jq -s '.[0] * .[1]' entitledregistryconfigjson "$registry_server" > entitledregistryconfigjson-temp
        RETVAL=$?
        if [ $RETVAL -gt 0 ]; then
          exitInstallationWithErrorMessage "[ERROR]: jq -s entitledregistryconfigjson $registry_server failed..."
        fi

        mv entitledregistryconfigjson-temp entitledregistryconfigjson
        rm "$registry_server"
    else
        mv "$registry_server" entitledregistryconfigjson
    fi
  done

  oc get secret pull-secret -n openshift-config --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode > dockerconfigjson
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    exitInstallationWithErrorMessage "[ERROR]: oc get secret pull-secret failed..."
  fi

  jq -s '.[0] * .[1]' dockerconfigjson entitledregistryconfigjson > dockerconfigjson-merged
  RETVAL=$?
  if [ $RETVAL -gt 0 ]; then
    exitInstallationWithErrorMessage "[ERROR]: jq -s dockerconfigjson entitledregistryconfigjson failed..."
  fi

  result=$(oc set data secret/pull-secret -n openshift-config --from-file=.dockerconfigjson=dockerconfigjson-merged 2>&1 )
  RETVAL=$?

  if [ $RETVAL -gt 0 ]; then
    echo "[ERROR]: oc set data secret/pull-secret failed..."
    exitInstallationWithErrorMessage "[ERROR DETAIL]: $result"
  else
    echo "$result"
  fi

  rm entitledregistryconfigjson
  rm dockerconfigjson
  rm dockerconfigjson-merged

}
