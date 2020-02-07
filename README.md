# bim

git push to scale your Elastic nodes \o/

[Clone and make this repo](#Install) and you get 1 Elasticsearch cluster with 1 node managed by [ECK](https://www.elastic.co/guide/en/cloud-on-k8s/current/index.html) continuously [synchronized in a Kubernetes cluster](https://cloud.google.com/kubernetes-engine/docs/add-on/config-sync/how-to/installing) from this [manifest](https://github.com/thbkrkr/bim/blob/e010262effa102318071d248055f6c632b9ea375/bam/namespaces/elastic/staging.yml#L1-L18).

```
> k get -n elastic es,po
NAME                                                 HEALTH   NODES   VERSION   PHASE   AGE
elasticsearch.elasticsearch.k8s.elastic.co/staging   green    1       7.5.2     Ready   42s

NAME                      READY   STATUS    RESTARTS   AGE
pod/staging-es-master-0   1/1     Running   0          42s

```

Edit the [node count](https://github.com/thbkrkr/bim/blob/e010262effa102318071d248055f6c632b9ea375/bam/namespaces/elastic/staging.yml#L13).

```diff
diff --git a/bam/namespaces/elastic/staging.yml b/bam/namespaces/elastic/staging.yml
index 1717045..5250f6a 100644
--- a/bam/namespaces/elastic/staging.yml
+++ b/bam/namespaces/elastic/staging.yml
@@ -10,7 +10,7 @@ spec:
         type: LoadBalancer
   nodeSets:
   - name: master
-    count: 1
+    count: 3
     config:
       node.master: true
       node.data: true
```

```sh
> g commit -m "Scale to 3 master nodes"
[master 6162854] Scale to 3 master nodes
 1 file changed, 1 insertion(+), 1 deletion(-)

> g push
Énumération des objets: 11, fait.
Décompte des objets: 100% (11/11), fait.
Compression par delta en utilisant jusqu'à 8 fils d'exécution
Compression des objets: 100% (5/5), fait.
Écriture des objets: 100% (6/6), 588 octets | 294.00 Kio/s, fait.
```

[6162854](https://github.com/thbkrkr/bim/commit/6162854ec07cd1c24596d784c9582a063b8c37cb) => 3 nodes :)

```sh
> k get -n elastic es,po
NAME                                                 HEALTH   NODES   VERSION   PHASE   AGE
elasticsearch.elasticsearch.k8s.elastic.co/staging   green    3       7.5.2     Ready   3m30s

NAME                      READY   STATUS    RESTARTS   AGE
pod/staging-es-master-0   1/1     Running   0          3m26s
pod/staging-es-master-1   1/1     Running   0          2m21s
pod/staging-es-master-2   1/1     Running   0          1m45s
```

### Install

Prerequisites: electricity, network, git, make, gcloud (for gsutil (sorry # todo: fix)), kubectl & 1 k8s cluster (# todo: give some help).

```sh

> git clone https://github.com/thbkrkr/bim && make -C bim

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