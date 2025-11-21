kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.0/standard-install.yaml # Gateway API installation

cilium install --wait --version 1.18.4 --namespace kube-system --values cilium/values.yaml # Cilium installation

kubectl apply -k cilium/private/bgp-loadbalancer # Private config for BGP loadbalancer

helm upgrade --install metrics-server metrics-server/metrics-server --namespace kube-system --version 3.13.0 # Metrics Server installation

kubectl create ns democratic-csi
kubectl label --overwrite namespace \
  democratic-csi pod-security.kubernetes.io/enforce=privileged \
  pod-security.kubernetes.io/audit=privileged \
  pod-security.kubernetes.io/warn=privileged
helm upgrade --install --values private/democratic-csi/zfs-generic-nvmeof.yaml --namespace democratic-csi zfs-nvmeof-ssd democratic-csi/democratic-csi --version 0.15.0
helm upgrade --install --values private/democratic-csi/zfs-generic-nfs.yaml --namespace democratic-csi zfs-nfs-ssd democratic-csi/democratic-csi --version 0.15.0

helm upgrade --install \
  cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --version v1.19.1 \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true

kubectl apply -k eks-webhook

kubectl apply -k letsencrypt-issuer
