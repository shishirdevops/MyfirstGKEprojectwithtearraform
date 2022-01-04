#!/bin/bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install prometheus bitnami/kube-prometheus
kubectl port-forward --namespace default svc/prometheus-kube-prometheus-prometheus 9090:9090
helm install grafana bitnami/grafana
echo "$(kubectl get secret grafana-admin --namespace default -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 --decode)"
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace default port-forward $POD_NAME 3000
##https://tanzu.vmware.com/developer/guides/observability-prometheus-grafana-p1/##
