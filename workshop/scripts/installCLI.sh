#!/bin/sh

mkdir cli
cd cli

echo "Installing CLI in $HOME/cli ..."
#CLI from AWS cluster, AWS on a later version of OpenShift
curl -LO --insecure https://downloads-openshift-console.apps.dev-advocate.rhm-awsocp.com/amd64/linux/oc.tar

tar -xvf oc.tar
rm oc.tar

./oc version

echo -e "\n" >> ~/.profile
echo "PATH=$HOME/cli:\${PATH}" >> ~/.profile

echo "CLI install complete."
echo "Run the following command to set the path:  source .profile"
cd

