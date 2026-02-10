# Setup K8s Env

## Create cluster

```bash
sind create --cluster swarm \
  --image=docker:dind \
  --managers="1" \
  --workers="2" \
  -p 14443:8443 \
  -p 14080:8000 \
  --network-name="swarm"
```

## Connect docker cli to cluster

```bash
$(sind env --cluster swarm)
```

## Deploy Traefik

```bash
docker stack deploy -c ./docker/traefik/traefik.yaml traefik --detach=true
```

## Deploy whoami

```bash
docker stack deploy -c ./docker/whoami/whoami.yaml whoami --detach=true
```
