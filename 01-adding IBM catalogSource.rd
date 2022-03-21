############
adding IBM catalogSource
https://www.ibm.com/docs/en/cloud-paks/cp-integration/2021.4?topic=installing-adding-catalog-sources-online-openshift-cluster
############


```
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-operator-catalog
  namespace: cp4i-poc
spec:
  displayName: IBM Operator Catalog
  image: 'icr.io/cpopen/ibm-operator-catalog:latest'
  publisher: IBM
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 45m
```

oc apply -f filename

############
installation mode is a specific namespace on the cluster
https://www.ibm.com/docs/en/cloud-paks/cp-integration/2021.4?topic=installing-operators-using-cli
############

vi operator-group.yaml

```
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: ibm-integration-operatorgroup
  namespace: cp4i-poc
spec:
  targetNamespaces:
  - cp4i-poc
```
oc apply -f operator-group.yaml -n cp4i-poc


vi subscription.yaml
```
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-cp-integration
  namespace: cp4i-poc
spec:
  channel: v1.5
  name: ibm-cp-integration
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
```

oc apply -f subscription.yaml -n cp4i-poc


############
Validating installation of an operator
########################

oc get csv -n cp4i-poc




