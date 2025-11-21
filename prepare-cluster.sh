kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.0/standard-install.yaml # Gateway API installation

cilium install --wait \
  --namespace kube-system \
  --values cilium/values.yaml \
  --version 1.18.4 # Cilium installation

kubectl apply -k cilium/private/bgp-loadbalancer # Private config for BGP loadbalancer

helm install metrics-server metrics-server/metrics-server \
  --namespace kube-system \
  --version 3.13.0 # Metrics Server installation

kubectl create ns democratic-csi
kubectl label --overwrite namespace \
  democratic-csi pod-security.kubernetes.io/enforce=privileged \
  pod-security.kubernetes.io/audit=privileged \
  pod-security.kubernetes.io/warn=privileged
helm install zfs-nvmeof-ssd democratic-csi/democratic-csi \
  --namespace democratic-csi \
  --values democratic-csi/zfs-generic-nvmeof.yaml \
  --values democratic-csi/private/zfs-generic-nvmeof.yaml \
  --version 0.15.0
helm install zfs-nfs-ssd democratic-csi/democratic-csi \
  --namespace democratic-csi \
  --values democratic-csi/zfs-generic-nvmeof.yaml \
  --values democratic-csi/private/zfs-generic-nfs.yaml \
  --version 0.15.0

helm install cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --namespace cert-manager --create-namespace \
  --version 1.19.1 \
  --set crds.enabled=true

kubectl apply -k eks-webhook

kubectl apply -k letsencrypt-issuer

kubectl apply -k argocd/prepare
helm install argocd argo/argo-cd \
  --namespace argocd \
  --values argocd/helm-values.yaml \
  --values private/argocd/helm-values.yaml \
  --version 5.45.6
