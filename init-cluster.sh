cd cluster
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
source private/cluster.env
envsubst < cluster.yaml > "$tmp"
omnictl cluster template sync -f "$tmp"
# temp removed automatically when the shell exits
