# Setup K8s Env

## Create cluster

```bash
sind create --cluster sup \
  --image=docker:dind \
  --managers="1" \
  --workers="2" \
  -p 14443:8443 \
  -p 14080:8000 \
  --network-name="sup"
```

## Connect docker cli to cluster

```bash
$(sind env --cluster sup)
```

## Deploy Traefik

```bash
docker stack deploy -c ./docker/traefik/traefik.yaml traefik --detach=true
```

## Deploy whoami

```bash
docker stack deploy -c ./docker/whoami/whoami.yaml whoami --detach=true
```

## Cleanup

```bash
unset DOCKER_HOST
sind delete --cluster sup
```
