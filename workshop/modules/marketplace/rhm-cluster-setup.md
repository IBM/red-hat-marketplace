# Cluster Setup

OpenShift clusters must be added to your Marketplace workspace prior to deploying software from the marketplace. Marketplace provides you the flexibility to use any OpenShift cluster irrespective of its location. The cluster's location can be public or private and can be added to the list as long as the cluster can communicate with the Marketplace server.

The cluster setup process will be completed by the cluster admins. This workshop will use OpenShift clusters on AWS and IBM Cloud. Use the cluster admin credentials provided by the instructors. 

## Step 1 - Add the IBM Cloud OpenShift (ROKS) cluster

### Step 1.1 - Add cluster in the Marketplace portal
In the Marketplace portal, go to `Wrokspace > Clusters` and click on `Add cluster` button.

![Clusters page](images/rhm-cluster-landing.png)

In the `Add cluster` page, enter a pull secret name and click on the button `Generate Secret`. Click on the download icon to save the pull secret for later use. The list of generated pull secrets is availble at `My Account > Pull secrets` page.

![Pull secret](images/rhm-cluster-pull-secret.png)

Run the install script in your command line terminal. Instructions for running the script are provided in the next section. [Note that pull secret generated in the earlier step is automatically replaced as the input parameter for the install script.]

![Install script](images/rhm-cluster-install-script.png)

### Step 1.2 - Terminal access and CLI setup

Login to [IBM Cloud](https://cloud.ibm.com) and switch the account setup for the workshop.
Start a cloud shell by clicking on the `IBM Cloud Shell` icon.

![Cloud console](images/rhm-ibm-cloud-shell-start.png)

OpenShift [CLI](https://docs.openshift.com/container-platform/4.3/cli_reference/openshift_cli/getting-started-cli.html) and [jq](https://stedolan.github.io/jq/download/) JSON processor are the prerequisites needed to install the Marketplace operator. These tools are preinstalled in the cloud shell, however, we will upgrade the OpenShift CLI to a newer version. 

![Cloud shell](images/rhm-ibm-cloud-shell.png)

To upgrade the CLI, run the commands listed below:

```
source <(curl -s https://raw.githubusercontent.com/IBM/red-hat-marketplace/master/workshop/scripts/installCLI.sh)
source ~/.profile
oc version
jq --version
```
Expected output:
```
rojan@cloudshell:~$ source <(curl -s https://raw.githubusercontent.com/IBM/red-hat-marketplace/master/workshop/scripts/installCLI.sh)
Installing CLI in /home/rojan/cli ...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 74.6M  100 74.6M    0     0  24.1M      0  0:00:03  0:00:03 --:--:-- 24.1M
oc
Client Version: openshift-clients-4.5.0-202006231303.p0-4-gb66f2d3a6
CLI install complete.
Run the following command to set the path:  source .profile
rojan@cloudshell:~$ source ~/.profile
rojan@cloudshell:~$ oc version
Client Version: openshift-clients-4.5.0-202006231303.p0-4-gb66f2d3a6
rojan@cloudshell:~$ jq --version
jq-1.6
```

### Step 1.3 - Log in to OpenShift cluster

Find the cluster in the IBM Cloud console.

![Locate Cluster](images/rhm-cluster-locate.png)

Click on it to open the cluster details page. Finally, click on 'OpenShift web console` button to open the console.

![Cluster details](images/rhm-cluster-details.png)

Copy the login command.

![Cluster details](images/rhm-cluster-login-command.png)

Run the login command from the CLI terminal.

![Cluster details](images/rhm-cluster-login.png)

### Step 1.4 - Install the Marketplace operator

Run the command copied earlier from the `Add cluster` step in the CLI terminal. Give cluster the name `rhm-jumpstart-ibmcloud` when prompted during the install process.

Expected output:
```
rojanjose@cloudshell:~$ curl -sL https://marketplace.redhat.com/provisioning/v1/scripts/install-operator | bash -s -- -i 5e9ccb95a85d690013d1b9e0 -p eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQ
k0gTWFya2V0cGxhY2UiLCJpYXQiOjE1OTk2N5M4MTUsZmp0aSI6ImY3N2U3NmJmNmVhNDQ3M2M4YTkyMWMwZjljMzUyZTgzIn0.G6hAt9g8K6F7H03qvxCzCZ17sjlcmF8tdo6KTArXLnQ -a Automatic
true
==================================================================================
                   [INFO] Installing Red Hat Marketplace Operator...              
==================================================================================
/dev/stdin: line 146: uuidgen: command not found
> Cluster Name: 
Edit cluster name for easy reference in Red Hat Marketplace? [Y/n]
y
Enter Cluster Name: 
rhm-jumpstart-ibmcloud
 
Detected the following options: 
> Account Id: 5e9ccb95a85d690013d1b9e0
> Cluster Name: rhm-jumpstart-ibmcloud
> Pull Secret: eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE1OTk3NjM4MTUsImp0aSI6ImY3N2U3NmJmNmVhNDQ3M2M4YTkyMWMwZjljMzUyZTgzIn0.G6hAt9g8K6F7H03qvxCzCZ17sjlcmF8tdo6
KTArXLnQ
> Marketplace Operator Approval Strategy: Automatic
Continue with installation? [Y/n]: 
 
Continue with installation? [Y/n]: 
y
 
STEP 1/5: Validating Namespace
Installing Red Hat Marketplace Operator
 
STEP 2/5: Installing the Red Hat Marketplace Operator. This might take several minutes
namespace/openshift-redhat-marketplace created
operatorgroup.operators.coreos.com/redhat-marketplace-operator created
secret/rhm-operator-secret created
subscription.operators.coreos.com/redhat-marketplace-operator created
Checking for Cluster Service Version
Checking for Custom Resource Definition
 
STEP 3/5: Creating Red Hat Marketplace Operator Config custom resource
marketplaceconfig.marketplace.redhat.com/marketplaceconfig created
 
STEP 4/5: Checking for Razee resources to be created
pod/rhm-watch-keeper-cdfdcb68f-gwdzs condition met
All Razee resources created successfully.
 
STEP 5/5: Applying global pull secret
W0910 18:53:53.656478    3441 helpers.go:549] --dry-run=true is deprecated (boolean value) and can be replaced with --dry-run=client.
W0910 18:53:53.995073    3452 helpers.go:549] --dry-run=true is deprecated (boolean value) and can be replaced with --dry-run=client.
secret/pull-secret data updated
Applying global pull secret succeeded
Install complete, all resource created.
==================================================================================
 
 
Red Hat Marketplace Operator successfully installed.
 
It may take a few minutes for your cluster to show up in the Marketplace console so you can install purchased software or trials.
 
Would you like to go back to the Red Hat Marketplace now? [Y/n]
n
rojanjose@cloudshell:~$ 
```

Verify the operator install correctly in the `Installed operators` page in OpenShift console. The operator is installed in the project `openshift-redhat-marketplace` and the status column should show `Succeeded`.

![Verify install](images/rhm-verify-operator-install.png)

Check the pods are up and running.

```
$ oc get pods -n openshift-redhat-marketplace
NAME                                               READY   STATUS      RESTARTS   AGE
prometheus-operator-77dd76b6c7-jnvdr               2/2     Running     0          9m48s
prometheus-rhm-marketplaceconfig-meterbase-0       5/5     Running     1          9m27s
prometheus-rhm-marketplaceconfig-meterbase-1       5/5     Running     1          9m27s
redhat-marketplace-operator-747f7c67bd-dfbwd       1/1     Running     0          9m37s
rhm-metric-state-57c8666b5b-rsgbs                  3/3     Running     0          9m47s
rhm-remoteresources3-controller-5b5558b786-c2g4q   1/1     Running     0          9m37s
rhm-watch-keeper-cdfdcb68f-gwdzs                   1/1     Running     1          9m36s
```

## Step 2: Add AWS cluster

Repeat the steps followed to add the ROKS cluster in order to add the second cluster running on AWS. 

## Step 2.1 - Install Marketplace Operator
Log into the AWS OpenShift console using the credenitals provided by the instructor.

Copy the login command and run it from the CLI terminal using the credentials 
```
rojanjose@cloudshell:~$ oc login --token=maUOkoKQ5LAAlyPpNOhBxZSGezl1-4cdBCwloKH4qh8w --server=https://api.dev-advocate.rhm-awsocp.com:6443
The server uses a certificate signed by an unknown authority.
You can bypass the certificate check, but any data you send to the server could be intercepted by others.
Use insecure connections? (y/n): y

Logged into "https://api.dev-advocate.rhm-awsocp.com:6443" as "kube:admin" using the token provided.

You have access to 69 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "default".
```

Run the Marketplace install script copied from the earlier step. Give cluster the name `rhm-jumpstart-aws` when prompted during the install process.

Expected output:
```
rojanjose@cloudshell:~$ curl -sL https://marketplace.redhat.com/provisioning/v1/scripts/install-operator | bash -s -- -i 5e9ccb95a85d690013d1b9e0 -p eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQ
k0gTWFya2V0cGxhY2UiLCJpYXQiOjE1OTk2N5M4MTUsZmp0aSI6ImY3N2U3NmJmNmVhNDQ3M2M4YTkyMWMwZjljMzUyZTgzIn0.G6hAt9g8K6F7H03qvxCzCZ17sjlcmF8tdo6KTArXLnQ -a Automatic
true
==================================================================================
                   [INFO] Installing Red Hat Marketplace Operator...              
==================================================================================
/dev/stdin: line 146: uuidgen: command not found
> Cluster Name: 
Edit cluster name for easy reference in Red Hat Marketplace? [Y/n]
y
Enter Cluster Name: 
rhm-jumpstart-aws
 
Detected the following options: 
> Account Id: 5e9ccb95a85d690013d1b9e0
> Cluster Name: rhm-jumpstart-ibmcloud
> Pull Secret: eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE1OTk3NjM4MTUsImp0aSI6ImY3N2U3NmJmNmVhNDQ3M2M4YTkyMWMwZjljMzUyZTgzIn0.G6hAt9g8K6F7H03qvxCzCZ17sjlcmF8tdo6
KTArXLnQ
> Marketplace Operator Approval Strategy: Automatic
Continue with installation? [Y/n]: 
 
Continue with installation? [Y/n]: 
y
 
STEP 1/5: Validating Namespace
Installing Red Hat Marketplace Operator
.....
......
```

Verify the operator installed correctly under the project `openshift-redhat-marketplace` and the status column should show a value of `Succeeded`.

![Verify install](images/rhm-verify-operator-install-aws.png)

Check the pods are up and running.

```
$ oc get pods -n openshift-redhat-marketplace
NAME                                               READY   STATUS    RESTARTS   AGE
prometheus-operator-586c8b7696-2w8kc               2/2     Running   0          6h34m
prometheus-rhm-marketplaceconfig-meterbase-0       5/5     Running   1          15d
prometheus-rhm-marketplaceconfig-meterbase-1       5/5     Running   0          15d
redhat-marketplace-operator-7c455fcf6c-p56q6       1/1     Running   0          15d
rhm-metric-state-5fbb6d95ff-hdsjk                  3/3     Running   0          15d
rhm-remoteresources3-controller-5cc6b4945b-lpc2v   1/1     Running   0          15d
rhm-watch-keeper-5ddb67c5d7-ff8mk                  1/1     Running   1          15d
```

## Step 3: Validate clusters visiblity
All users registered with the organization account should now check the clusters page and ensure that both IBM and AWS clusters are visibile.

![View cluster list](images/rhm-cluster-list.png)


## Using Marketplace with CRC
Follow the instructions as shown [here](../../articles/rhm-crc/rhm-with-crc.md) to setup Marketplace on your local machine. 