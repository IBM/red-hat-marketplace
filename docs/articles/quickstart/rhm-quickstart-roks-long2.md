# Red Hat Marketplace Quickstart

As hybrid cloud becomes the preferred cloud architecture among enterprises, the IT teams are seeking ways to simplify how they buy, deploy and manage container based software across many clouds. Red Hat Marketplace offers a unified experience to purchase containerized sofware from a comprehensive catalog backed by leading cloud vendors, deploy across all clouds using the OpenShift Contianer Platform, monitor software spend, track license usage and expirations. 

This article will walk through the process of account registration, cluster setup and softare trial through Red Hat Marketplace.

### Setup Marketplace account
Go to [Red Hat Marketplace](https://marketplace.redhat.com/) and login with your IBM ID or Red Hat ID. Create your [IBM](https://www.ibm.com/account/reg/us-en/signup?formid=urx-19776) or [Red Hat](https://www.redhat.com/wapps/ugc/register.html) id if you do not have one. This article uses an IBM ID for the purposes of demonstration.
Fill in the information requested at the registration page. For `Account type`, select `Company` if you are registering the account for business purposes,  else select `Personal`. Click Next.

![RHM Registration](images/rhm-registration.png){: style="height:500px"}

Payment options can be setup with either a credit card or an invoice.  Using the invoice option requires you to have an `IBM Customer number` and a `Purchase order number`.

![RHM payment setup](images/rhm-payment-setup.png){: style="height:300px"}

You will see the landing page after the registration completes. Browse through the catalog of containerized software ready to install into your OpenShift cluster.

![RHM payment setup](images/rhm-landing.png)

### Add OpenShift cluster
OpenShift clusters must be added to your Marketplace workspace prior to deploying your choice of software. Marketplace provides you the flexibility to use any OpenShift cluster irrespective of its location. The cluster's location can be public or private as long as the cluster can communicate with the Marketplace server.

#### Prerequisites

OpenShift Cluster:  For this article we have chosen to use a managed OpenShift cluster on IBM cloud. If you do not have a cluster, create one by following this [link.](https://cloud.ibm.com/kubernetes/overview?platformType=openshift)

Deployment Key: A deployment key is required to link your OpenShift cluster to the marketplace. Select the drop down from the top right corner and go to `My Account` page.

![RHM my account page](images/rhm-myaccount.png){: style="height:250px"}

Note that this page provides you access to all the account management functions such as account information, access permissions, spending, offers and keys. Select `Deployment keys` and then click on `Create key`.   

![RHM my account page](images/rhm-create-deployment-key.png){: style="height:400px"}

Copy the key and save it in a secure place for later use prior to clicking the `Save` button.

![RHM my account page](images/rhm-deployment-key-save.png){: style="height:400px"}


Now, let's proceed with adding the OpenShift cluster. Select `Workspace > Clusters` and click on `Add cluster`

Enter a name that best represents the cluster you want to add.

Install the additional prerequites (CLIs and jq) required to run the install script. 
Login to your cluster using the `oc login` command with the `admin` credentials.

Run the operator install script and provide the deployment key created in the prior step as the input parameter. Note that account id and <--id> should be prepopulated.
```
curl -sL https://marketplace.redhat.com/provisioning/v1/scripts/install-rhm-operator | bash -s <account-id> bca6d535-6bca-4741-951d-35f6295d55a0 <deployment-key>
```
You should see the flowing output on a successful completion:
```
==================================================================================
                    [INFO] Installing Red Hat Marketplace Operator...
==================================================================================
STEP 1/6: Creating Namespace...
namespace/redhat-marketplace-operator created
STEP 2/6: Creating Red Hat Marketplace Operator Group...
operatorgroup.operators.coreos.com/redhat-marketplace-operator created
STEP 3/6: Creating Red Hat Marketplace Operator Subscription...
Checking for Cluster Service Version...
Checking for Custom Resource Definition...
subscription.operators.coreos.com/redhat-marketplace-operator created
STEP 4/6: Applying global pull secret...
secret/pull-secret data updated
STEP 5/6: Applying Red Hat Marketplace Operator Secret...
secret/rhm-operator-secret created
STEP 6/6: Creating Red Hat Marketplace Operator Config Custom Resource...
marketplaceconfig.marketplace.redhat.com/marketplaceconfig created
Red Hat Marketplace Operator successfully installed
```

Click on `Add cluster` button to complete the add cluster step. The cluster should appear in the `Clusters` page with the status as `Registered`. (wait for an hour to register if the status shows `Agent not installed`)

![RHM cluster list](images/rhm-add-cluster-list.png){: style="height:300px"}

??? Reach out to Marketplace technical support via [Slack??]() if you encounter an error and need help to resolve the issue. ( or create a support case in Marketplace???)

Check the list of installed operators in your OpenShift cluster. Red Hat Marketplace operator should be one of them.

![RHM operator list](images/rhm-operator-list.png)

One last step - if your cluster is running on IBM Cloud then run the following command to reload the worker nodes. This step may take 20-30 minutes. 
`ibmcloud ks worker reload --cluster <cluster-id> --worker <worker-node-name>`

Use `ibmcloud ks clusters` and `ibmcloud ks workers --cluster <cluster-id>` to determine the cluster id and node names. 

```
Reload worker? [kube-bqegbk1w00v8gmbt37l0-rjrhmsummit-default-000001d8] [y/N]> y
Reloading workers for cluster rhm-test-cluster...
Processing kube-bqegbk1w00v8gmbt37l0-rjrhmsummit-default-000001d8...
Processing on kube-bqegbk1w00v8gmbt37l0-rjrhmsummit-default-000001d8 complete.
```

Now you are ready to try any software from the catalog!

### Try software

Let's see how the `Free Trial` option works. Go to the Marketplace catalog and search for `Crunchy PostgreSQL` and select the tile.
The product page gives you an overview, documentation and pricing options associated with the product selected. Cick on `Free Trail` button.

![RHM product free trial](images/rhm-crunchy-free-trial.png){: style="height:300px"}

Next, the purchase summary will show the `Subscription term` and total cost is $0.00. Click `Start trial`.
Go back to `Workspace > My Software` to view the list of purchased software.

Create a project in your OpenShift cluster where you want the operator to be installed.
```
oc new-project crunchy-test
```
Select the `Crunchy PostgreSQL` tile and select the `Operators` tab. Click on `Install Operator` button.
Leave the default selection for `Update channel` and `Approval strategy`. Select the cluster and namespace scope for the operator and click `Install`.

![RHM product operator install](images/rhm-crunchy-operator-install.png){: style="height:500px"}

A message as shown below appears at the top of your screen indicating the install process initiated in the cluster.

![RHM product request initiate](images/rhm-operator-install-request-initiate.png)

Log into your OpenShift cluster and look under `Operators > Installed Operators` to confirm the install was successfull.

![RHM product request initiate](images/rhm-crunchy-install-success.png)

Congratultions, you are now ready to install the Crunchy PostgreSQL cluster!

### Conclusion

In a follow on series, we will dive deeper into how Markertplace helps you rapidly take an idea from PoC to production scale application. You will also get to see the benfits of having a single place to manage the software consumption for your hybrid cloud applications.


 StorageClass: ibmc-file-gold

 Storage > Persistent Volume Claims, status should be shown as Bound. 

 ```
 $ kubectl run -it --rm cockroach-client \
--image=cockroachdb/cockroach \
--restart=Never \
--command -- \
./cockroach sql --insecure --host=example-cockroachdb-public.cockroachdb-test
If you don't see a command prompt, try pressing enter.
root@example-cockroachdb-public.cockroachdb-test:26257/defaultdb>
 ```


```
kubectl run -it --rm cockroach-client \
--image=cockroachdb/cockroach \
--restart=Never \
--command -- \
./cockroach sql --insecure --host=example-cockroachdb-public.cockroachdb-test
If you don't see a command prompt, try pressing enter.
root@example-cockroachdb-public.cockroachdb-test:26257/defaultdb> CREATE USER IF NOT EXISTS maxroach;
CREATE USER 1

Time: 13.604101ms

root@example-cockroachdb-public.cockroachdb-test:26257/defaultdb> CREATE DATABASE bank;
CREATE DATABASE

Time: 15.0454ms

root@example-cockroachdb-public.cockroachdb-test:26257/defaultdb> GRANT ALL ON DATABASE bank TO maxroach;
GRANT

Time: 14.835156ms

root@example-cockroachdb-public.cockroachdb-test:26257/defaultdb> \q
pod "cockroach-client" deleted
```


```
oc project cockroachdb-test
Now using project "cockroachdb-test" on server "https://c100-e.us-east.containers.cloud.ibm.com:32345".

kubectl get pods
NAME                             READY   STATUS      RESTARTS   AGE
cockroachdb-7486949c78-kdvcm     1/1     Running     0          46m
example-cockroachdb-0            1/1     Running     0          36m
example-cockroachdb-1            1/1     Running     0          36m
example-cockroachdb-2            1/1     Running     0          36m
example-cockroachdb-init-l5m56   0/1     Completed   0          36m

kubectl port-forward example-cockroachdb-0 8080
Forwarding from [::1]:8080 -> 8080

```
