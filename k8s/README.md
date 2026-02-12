# K8s prep env

## Create the K8s platform

```bash
k3d cluster create sup --port 13080:80@loadbalancer --port 13443:443@loadbalancer --k3s-arg "--disable=traefik@server:0"
```

## Deploy Traefik

### generate certs

```bash
bash k8s/traefik/gencert.sh
```

### create traefik ns

```bash
kubectl create ns traefik
```

### Create cert secret

```bash
kubectl -n traefik create secret tls local-wildcard --cert=certs/generated/localwildcard.crt --key=certs/generated/localwildcard.key
```

```bash
helm upgrade --install traefik traefik/traefik --create-namespace --namespace traefik --values k8s/traefik/traefik.yaml
```

### Add Traefik dashboard and Grafana ingresses

```bash
kubectl apply -f k8s/traefik/dashboard.yaml
```

## Test

### create apps ns

```bash
kubectl create ns apps
```

### Deploy first test

```bash
kubectl apply -f k8s/1/
```

### Deploy second test

```bash
bash k8s/2/gencert.sh
kubectl -n apps create secret tls gohellocert --cert=certs/generated/gohello.crt --key=certs/generated/gohello.key
kubectl -n apps create secret generic ca --from-file=ca.crt=certs/generated/ca.crt
kubectl apply -f k8s/2/
```

## Cleanup

```bash
k3d cluster delete sup
rm -rf certs/generated/*
```
