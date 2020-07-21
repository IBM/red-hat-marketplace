# Trying Cortex Certifai

## Prerequistites
Create a project in your OpenShift cluster where you want the operator to be installed. Prefix the project name with your workshop username.

```text
oc new-project ##username##-cortex-certifai
```

## Try software

### Operator install

The marketplace offers a wide variety of products across twelve categories. Let's see how a developer can try Cortex Certifai. 

Create a project `cortex-certifai-test` in your CodeReady Containers cluster.

Go to the [Marketplace catalog](https://marketplace.redhat.com/en-us) and search for Cortex Certifai. Select the tile and click on `Free trial` to start your 30 days trial.

![Try Cortex](images/crc-cortexcertifai-trial.png)

Go to `Workspace > My Software` and click on the `Install operator` icon.

![Install Cortex](images/crc-cortexcertifai-tile-install.png)

Select the CodeReady Containers cluster from the list of `Target clusters` and then pick the `Namespace Scope` where the operator should get installed.

![Install Cortex](images/crc-cortexcertifai-install-dialog.png)

Login to the cluster to verify the operator installed successfully.

![Cerify Cortex Install](images/crc-cortexcertifai-install-verify.png)

Proceed to the `Cortex Certifai Operator` tab to install operands or instances for the Cortex Certifai operator.

The operators can be installed directly from the cluster. The Red Hat Marketplace operators become available in the Operator Hub catalog after the Marketplace operator is installed. To install a product directly from the CodeReady Containers, login to the cluster, go to `Operators > OperatorHub`, search and install.

![Cerify Cortex Install from OperatorHub](images/crc-cortexcertifai-install-operatorhub.png)

Note: `Marketplace` should appear as a filter parameter under `Product type` in the OpertorHub search options.


### Uninstalling an Operator

Uninstall the Cortex Certifai operator by selecting the `Uninstall Operator`. The operator for the cluster will automatically delist from the Marketplace product operators page.

![Cerify Cortex Uninstall](images/crc-cortexcertifai-uninstall.png)
















Select the `PostgreSQL` tile and then select the `Operators` tab. Click on `Install Operator` button. Leave the default selection for `Update channel` and `Approval strategy`. Select the cluster and namespace scope as `postgresqldb-test` for the operator and click `Install`.

![Operator install](images/rhm-postgresqldb-operator-install-dialog.png)

A message as shown below appears at the top of your screen indicating the install process initiated in the cluster.

![Request initiate](images/rhm-operator-install-request-initiate.png)

Log into your OpenShift cluster and look under `Operators > Installed Operators` to confirm the install was successful. The operator should list under the project `postgresqldb-test`.

![Successful install](images/rhm-postgresqldb-install-success.png)


## Create Database

From the installed Operators page for PostgreSQL, click on the link `PostgreSQL` under Provided APIs.

![Create instance](images/rhm-postgresqldb-instance-install.png)

Click on `Create Cockroachdb` button. Accept the default YAML and click on `Create` button. \[Follow the instructions [here](https://www.postgresqllabs.com/docs/stable/orchestrate-a-local-cluster-with-kubernetes.html) to set up the database in a secure mode.\]

![Install YAML](images/rhm-postgresqldb-install-yaml.png)

PostgreSQL pods should come up when the database install completes. Run the following commands to check the status.

```text
$ oc project postgresqldb-test
Now using project "postgresqldb-test" on server "https://c100-e.us-east.containers.cloud.ibm.com:32345".
```

```text
$ kubectl get pods
NAME                             READY   STATUS      RESTARTS   AGE
postgresqldb-7486949c78-kdvcm     1/1     Running     0          46m
example-postgresqldb-0            1/1     Running     0          36m
example-postgresqldb-1            1/1     Running     0          36m
example-postgresqldb-2            1/1     Running     0          36m
example-postgresqldb-init-l5m56   0/1     Completed   0          36m
```
Now, let's create a user and a database. We will use the following to command to spin up a PostgreSQL client.

```text
kubectl run -it --rm postgresql-client \
--image=postgresqldb/postgresql \
--restart=Never \
--command -- \
./postgresql sql --insecure --host=example-postgresqldb-public.postgresqldb-test
```

```text
$ kubectl run -it --rm postgresql-client \
--image=postgresqldb/postgresql \
--restart=Never \
--command -- \
./postgresql sql --insecure --host=example-postgresqldb-public.postgresqldb-test

If you don't see a command prompt, try pressing enter.
root@example-postgresqldb-public.postgresqldb-test:26257/defaultdb>
```

From the client command prompt, run the following SQL commands:

Create user `maxroach`

```text
CREATE USER IF NOT EXISTS maxroach;
```

```text
root@example-postgresqldb-public.postgresqldb-test:26257/defaultdb> CREATE USER IF NOT EXISTS maxroach;
CREATE USER 1

Time: 13.604101ms
```

Create the database `bank`

```text
 CREATE DATABASE bank;
```

```text
root@example-postgresqldb-public.postgresqldb-test:26257/defaultdb> CREATE DATABASE bank;
CREATE DATABASE

Time: 15.0454ms
```

Grant user the permission to update the database.

```text
GRANT ALL ON DATABASE bank TO maxroach;
```

```text
root@example-postgresqldb-public.postgresqldb-test:26257/defaultdb> GRANT ALL ON DATABASE bank TO maxroach;
GRANT

Time: 14.835156ms
```

Type `\q` to quit the client console.

```text
root@example-postgresqldb-public.postgresqldb-test:26257/defaultdb> \q
pod "postgresql-client" deleted
```

## Access Database

Now, let's view the results of the commands we ran in the earlier steps via the admin console. Console can be accessed at localhost wwith port forwarding.

```text
kubectl port-forward example-postgresqldb-0 8080
```

```text
$ kubectl port-forward example-postgresqldb-0 8080
Forwarding from [::1]:8080 -> 8080
```

The page should load the `cluster overview`

![Cluster overview](images/rhm-postgresqldb-cluster-overview.png)

Click on `DATABASES` from the left navigation panel.

jdbc:postgresql://127.0.0.1:26257/bank?sslmode=disable example-postgresqldb-public.postgresqldb-test.svc.cluster.local

![Database tables](images/rhm-postgresqldb-cluster-database.png)

## Conclusion

The PostgreSQL instance is now ready for use. 