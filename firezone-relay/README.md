# Firezone Relay Helm Chart

The Firezone relay acts as a STUN/TURN server, it must be accessible from outside of your network to work correctly. Therefore it requires more configuration than a Firezone gateway: https://www.firezone.dev/kb/architecture/core-components#relay

```bash
helm repo add intuinewin https://intuinewin.github.io/helm-charts/
helm install \
  --set "config.token.value=<TOKEN>" \
  --set "config.publicIPV4Addr=x.x.x.x" \
  --set "config.publicIPV6Addr=xxxx:xxxx::xxxx" \
  --set "config.TURNLowestPort=55555" \
  --set "config.TURNHighestPort=55666" \
  my-relay intuinewin/firezone-relay
```

If you selfhost Firezone, you'll also need to set `config.apiUrl`

You must provide the IPV4 and/or IPV6 on which clients or gateways can contact the relay. It must be accessible on multiple ports:
- `config.listenPort` (UDP)
- `config.TURNLowestPort` - `config.TURNHighestPort` (UDP)

This helm chart only creates a service with these ports, you need to make it accessible on the provided IPV4/IPV6.

See [values.yaml](./values.yaml) for all customization values
