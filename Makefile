
all: sync-operator eck sync-bam

sync-operator:
	gsutil cp gs://config-management-release/released/latest/config-sync-operator.yaml config-sync-operator.yml
	kubectl apply -f config-sync-operator.yml
	rm config-sync-operator.yml

sync-operator-status:
	kubectl -n kube-system get pods -l k8s-app=config-management-operator

eck:
	curl https://download.elastic.co/downloads/eck/1.0.0/all-in-one.yaml -sL | kubectl apply -f-

sync-bam:
	kubectl apply -f config.yml

sync-bam-status:
	kubectl get all -n config-management-system

clean:
	kubectl delete ns config-management-system elastic-system elastic