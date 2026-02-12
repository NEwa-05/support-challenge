# Setup file Env

## Create tree

```bash
mkdir -p file/hub k8s/hub root/hub swarm/hub
```

## download Hub binary for file provider

```bash
curl -OL https://github.com/traefik/traefik/releases/download/v3.6.8/traefik_v3.6.8_darwin_arm64.tar.gz && tar -xzf traefik_v3.6.8_darwin_arm64.tar.gz traefik && mv traefik ./vm/traefik/traefik && rm -rf traefik_v3.6.8_darwin_arm64.tar.gz traefik-hub-darwin-arm64
```

## Run Whoami

```bash
docker run -d -p 12880:80 --name=whoami-dockervm traefik/whoami -name vm host
```

## start Traefik

```bash
rm -rf vm/traefik/logs/traefik.log
rm -rf vm/traefik/logs/access.log
./vm/traefik/traefik --configfile=vm/traefik/static.yaml
```
