# K8s prep env

## Create the K8s platform

```bash
k3d cluster create sup --port 13080:80@loadbalancer --port 13443:443@loadbalancer --k3s-arg "--disable=traefik@server:0"
```

## Observability tools

```bash
kubectl create ns observability
```

### Deploy OTel collector

```bash
helm upgrade --install otel-collector open-telemetry/opentelemetry-collector -n observability --values k8s/tools/observability/otel-collector/values.yaml 
```

### Deploy loki

```bash
helm upgrade --install loki grafana/loki -n observability --values k8s/tools/observability/loki/values.yaml
```

### Deploy Jaeger

```bash
kubectl apply -f k8s/tools/observability/jaeger
```

### Deploy Prometheus stack

```bash
helm upgrade --install promtail grafana/promtail -n observability --values k8s/tools/observability/promtail/values.yaml
kubectl create configmap grafana-traefik-dashboards --from-file=k8s/tools/observability/prometheus-stack/traefik.json -o yaml --dry-run=client -n observability | kubectl apply -f - && kubectl label -n observability cm grafana-traefik-dashboards grafana_dashboard=true
helm upgrade -i prometheus-stack prometheus-community/kube-prometheus-stack -f k8s/tools/observability/prometheus-stack/values.yaml -n observability
```

## Deploy Traefik

### generate certs

```bash
bash certs/gencert.sh
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
kubectl apply -f k8s/tools/observability/prometheus-stack/ingress.yaml
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
kubectl -n apps create secret tls gohellocert --cert=certs/generated/gohello.crt --key=certs/generated/gohello.key
kubectl -n apps create secret generic ca --from-file=ca.crt=certs/generated/ca.crt
kubectl apply -f k8s/2/
```

## Cleanup

```bash
k3d cluster delete sup
```
