# bim

git push to scale your Elastic nodes \o/

```
> k get -n elastic es,po
NAME                                                 HEALTH   NODES   VERSION   PHASE   AGE
elasticsearch.elasticsearch.k8s.elastic.co/staging   green    1       7.5.2     Ready   42s

NAME                      READY   STATUS    RESTARTS   AGE
pod/staging-es-master-0   1/1     Running   0          42s

```

# Install

```sh
> m
gsutil cp gs://config-management-release/released/latest/config-sync-operator.yaml config-sync-operator.yml
Copying gs://config-management-release/released/latest/config-sync-operator.yaml...
/ [1 files][  6.4 KiB/  6.4 KiB]
Operation completed over 1 objects/6.4 KiB.

kubectl apply -f config-sync-operator.yml

customresourcedefinition.apiextensions.k8s.io/configmanagements.configmanagement.gke.io configured
clusterrole.rbac.authorization.k8s.io/config-management-operator unchanged
clusterrolebinding.rbac.authorization.k8s.io/config-management-operator unchanged
serviceaccount/config-management-operator unchanged
deployment.apps/config-management-operator configured
namespace/config-management-system created
rm config-sync-operator.yml

curl https://download.elastic.co/downloads/eck/1.0.0/all-in-one.yaml -sL | kubectl apply -f-

customresourcedefinition.apiextensions.k8s.io/apmservers.apm.k8s.elastic.co configured
customresourcedefinition.apiextensions.k8s.io/elasticsearches.elasticsearch.k8s.elastic.co configured
customresourcedefinition.apiextensions.k8s.io/kibanas.kibana.k8s.elastic.co configured
clusterrole.rbac.authorization.k8s.io/elastic-operator unchanged
clusterrolebinding.rbac.authorization.k8s.io/elastic-operator unchanged
namespace/elastic-system created
statefulset.apps/elastic-operator created
serviceaccount/elastic-operator created
validatingwebhookconfiguration.admissionregistration.k8s.io/elastic-webhook.k8s.elastic.co configured
service/elastic-webhook-server created
secret/elastic-webhook-server-cert created

kubectl apply -f config.yml

configmanagement.configmanagement.gke.io/config-management unchanged
```