# Using CodeReady Containers with Marketplace

## CodeReady Containers

CodeReady Containers brings a minimal, preconfigured OpenShift 4.1 or newer cluster to your local laptop or desktop computer for development and testing purposes. CodeReady Containers is delivered as a Red Hat Enterprise Linux virtual machine that supports native hypervisors for Linux, macOS, and Windows 10.

CodeReady Containers is the quickest way to get started building OpenShift clusters. It is designed to run on a local computer to simplify setup and testing, and emulate the cloud development environment locally with all the tools needed to develop container-based apps. 

### CRC install
Follow the instructions as shown in this [video](https://www.youtube.com/watch?v=yp8LXEKlGSQ)
(https://developers.redhat.com/blog/2019/10/16/local-openshift/)

This tutorial will use CodeReady Containers on Windows.

#### Download
File and pull secret.
The messages shown below indicates your `crc setup` completed successfully.

```
PS C:\crc-windows-1.8.0-amd64> crc setup
INFO Checking if oc binary is cached
INFO Caching oc binary
INFO Checking if podman remote binary is cached
INFO Checking if CRC bundle is cached in '$HOME/.crc'
INFO Unpacking bundle from the CRC binary
INFO Checking if running as normal user
INFO Checking Windows 10 release
INFO Checking if Hyper-V is installed and operational
INFO Checking if user is a member of the Hyper-V Administrators group
INFO Checking if Hyper-V service is enabled
INFO Checking if the Hyper-V virtual switch exist
INFO Found Virtual Switch to use: Default Switch
Setup is complete, you can now run 'crc start' to start the OpenShift cluster
```

### Install Marketplace Prerequsites

Marletplace
Install [Windows subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)  
OpenShift CLI and [jq](https://stedolan.github.io/jq/download/) plugins are the other prerequisites needed to run the Marketplace install script. OpenShift CLI comes as part of CodeReady Container install. Install jq executable for windows as add it to the



Test bash is ready:
```
 bash --version
GNU bash, version 4.4.23(1)-release (x86_64-suse-linux-gnu)
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```

#### Start CodeReady Container

Once the install is complete, start CRC by running the command `crc start`.

Running as admin

```
PS C:\Users\> crc start
WARN A new version (1.11.0) has been published on https://cloud.redhat.com/openshift/install/crc/installer-provisioned
INFO Checking if oc binary is cached
INFO Checking if podman remote binary is cached
INFO Checking if running as normal user
INFO Checking Windows 10 release
INFO Checking if Hyper-V is installed and operational
INFO Checking if user is a member of the Hyper-V Administrators group
INFO Checking if Hyper-V service is enabled
INFO Checking if the Hyper-V virtual switch exist
INFO Found Virtual Switch to use: Default Switch
INFO Starting CodeReady Containers VM for OpenShift 4.3.8...
INFO Verifying validity of the cluster certificates ...
INFO Will run as admin: add dns server address to interface vEthernet (Default Switch)
INFO Check internal and public DNS query ...
WARN Failed public DNS query from the cluster: ssh command error:
command : host -R 3 quay.io
err     : Process exited with status 1
output  : ;; connection timed out; no servers could be reached
 :
INFO Check DNS query from host ...
INFO Starting OpenShift cluster ... [waiting 3m]
INFO
INFO To access the cluster, first set up your environment by following 'crc oc-env' instructions
INFO Then you can access it by running 'oc login -u developer -p developer https://api.crc.testing:6443'
INFO To login as an admin, run 'oc login -u kubeadmin -p yYdPx-pjmWe-b3kzz-jeZm3 https://api.crc.testing:6443'
INFO
INFO You can now run 'crc console' and use these credentials to access the OpenShift web console
Started the OpenShift cluster
WARN The cluster might report a degraded or error state. This is expected since several operators have been disabled to lower the resource usage. For more information, please consult the documentation
```

Note: The cluster started with few excpetions.
- Part install
- credentials

Run `crc console` to reach the CRC console. Login as admin using the credentials from the start command. 


![Admin Console](images/crc-admin-console.png)


### Add CRC Cluster

![Add Cluster](images/crc-add-cluster.png)

Login as admin from the command window.

```
oc login --token=wLXN6bDn_R4vJzd3UqEG12e8N_6PgKhlyr-1GrrdP04 --server=https://api.crc.testing:6443
```

Run the install script:

curl -sL https://marketplace.redhat.com/provisioning/v1/scripts/install-rhm-operator | bash -s 5e616369cea4170013e06453 3a58df5a-c8ae-4f7d-84ff-a22d51579352 <deployment_key>

bash -c 'curl -sL https://marketplace.redhat.com/provisioning/v1/scripts/install-rhm-operator | bash -s 5e616369cea4170013e06453 3a58df5a-c8ae-4f7d-84ff-a22d51579352 eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE1ODM4NjYwMzIsImp0aSI6IjUyOWM0ZTU5Njk2ZDRjNWQ4ZGQyZTFmMDk5ZDRhZDdlIn0.eXyDgQ2Zg5aC3AhoEaDFGD66K8k638KnG-vu2YgGWbg'


 .\curl -sL https://marketplace.redhat.com/provisioning/v1/scripts/install-rhm-operator | bash -s 5e616369cea4170013e06453 3a58df5a-c8ae-4f7d-84ff-a22d51579352 eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE1ODM4NjYwMzIsImp0aSI6IjUyOWM0ZTU5Njk2ZDRjNWQ4ZGQyZTFmMDk5ZDRhZDdlIn0.eXyDgQ2Zg5aC3AhoEaDFGD66K8k638KnG-vu2YgGWbg
/bin/bash: line 9: $'\r': command not found
/bin/bash: line 10: $'\r': command not found
/bin/bash: line 33: syntax error near unexpected token `else'
'bin/bash: line 33: `  else

### Install product








