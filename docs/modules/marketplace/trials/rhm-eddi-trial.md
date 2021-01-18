# Trying E.D.D.I

## Prerequistites

Create a project in your OpenShift cluster where you want the operator to be installed. Prefix the project name with your workshop username.

```text
oc new-project ##username##-eddi
```

## Try software

### Installing products using CLI commands

This section covers the steps to install E.D.D.I chatbot operator using CLI commands. The general instructions to install an operator is available [here](https://docs.openshift.com/container-platform/4.4/operators/olm-adding-operators-to-cluster.html).
Prior to using CLI install, ensure the entitlement for the software exists in the Red Hat Marketplace.

Disclaimer: The operators installed using the CLI will not show up in the list of installed opertroars in Red Hat Marketplace.

Get the list of Red Hat Marketplace Operators:

```bash
oc get packagemanifests -n openshift-marketplace | grep Marketplace
```

Find the package name for E.D.D.I Operator

```bash
oc get packagemanifests -n openshift-marketplace | grep eddi
eddi-operator-certified                      Certified Operators   16d
eddi-operator-certified-rhmp                 Red Hat Marketplace   16d
```

Describe the package `eddi-operator-certified-rhmp`:

```bash
oc describe packagemanifests eddi-operator-certified-rhmp  -n openshift-marketplace
```

Use the commands above to gather the information required to generate the `Operator group` and `Operator subscription` yaml files.

Operator group (eddioperatorgroup.yaml):

```yaml
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: eddi-og-redhat-marketplace
  namespace: eddi-trial
spec:
  targetNamespaces:
  - eddi-trial
```

Operator subscritpion (eddisub.yaml):

```yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: eddi-operator-certified-rhmp
  namespace: eddi-trial
spec:
  channel: alpha
  name: eddi-operator-certified-rhmp
  source: redhat-marketplace
  sourceNamespace: openshift-marketplace
```

Install the EDDI Operator:

```bash
oc apply -f eddioperatorgroup.yaml

operatorgroup.operators.coreos.com/eddi-og-redhat-marketplace unchanged

$ oc apply -f eddisub.yaml

subscription.operators.coreos.com/eddi-operator-certified-rhmp created
```

Ensure the subscription installed properly by running the command:

```bash
oc describe sub eddi-operator-certified-rhmp -n eddi-trial | grep -A5 Conditions

  Conditions:
    Last Transition Time:   2020-06-13T02:36:36Z
    Message:                all available catalogsources are healthy
    Reason:                 AllCatalogSourcesHealthy
    Status:                 False
    Type:                   CatalogSourcesUnhealthy
```

#### Troubleshooting

Commands to troubleshoot CodeReady Containers can be found [here](https://access.redhat.com/documentation/en-us/red_hat_codeready_containers/1.11/html/getting_started_guide/troubleshooting-codeready-containers_gsg)

The error below indicates the necessary entitlement does not exist for the product in Red Hat Marketplace:

```bash
Failed to pull image "registry.marketplace.redhat.com/rhm/labsai/eddi-operator@sha256:19ac4278f510422428b12c04aba572101e153e0804edaaeabc6600782ab38f75": rpc error: code = Unknown desc = Error reading manifest sha256:19ac4278f510422428b12c04aba572101e153e0804edaaeabc6600782ab38f75 in registry.marketplace.redhat.com/rhm/labsai/eddi-operator: errors: denied: requested access to the resource is denied unauthorized: authentication required
```

## Conclusion

The E.D.D.I instance is now ready for use.
