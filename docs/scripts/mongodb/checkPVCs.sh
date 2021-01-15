#!/bin/bash
#------------------------------------------------------------------------------------------
# Script:  checkPVCs.sh, 
#------------------------------------------------------------------------------------------

APIKey=

#Get all the clusters
clusterList=( $(ibmcloud ks clusters |  awk '{print $1}' | sed '1,2d') )
clusterCount=0
for cluster in "${clusterList[@]}"
do
 clusterCount=$((clusterCount+1))
 echo "${clusterCount} : ${cluster}"
done
  