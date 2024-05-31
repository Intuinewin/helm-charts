# Firezone Gateway Helm Chart

Firezone documentation about deploying gateways: https://www.firezone.dev/kb/deploy/gateways

## Quick Start

```bash
helm repo add intuinewin https://intuinewin.github.io/helm-charts/
helm install --set "config.token.value=<TOKEN>" my-gateway intuinewin/firezone-gateway
```

If you selfhost Firezone, you'll also need to set `config.apiUrl`

See [values.yaml](./values.yaml) for all customization values
