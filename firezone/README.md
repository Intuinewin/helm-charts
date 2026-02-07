# Firezone Helm Chart

### Firezone doesn't officially support self-hosting !

Before trying to deploy Firezone, please be aware of the architecture of the
project: https://www.firezone.dev/kb/architecture/core-components

Self hosting Firezone is not easy and the architecture is more complex than
Firezone 0.7. In order to deploy Firezone, many secrets and a postgres database
are needed. You must also not be afraid to read the Firezone source code !


### Notes:

Postgres:
  - `wal_level` must be set to `logical`
  - Some migrations require superuser rights
    - 20250428102100
    - 20250430195212

For some features of Firezone, you'll need to both:
  - Enable them globally in the chart `config.features.{}.enabled = true`
  - Enable them per account in the database

If you want to enable Location-restricted policies, you'll need a load
balancer which injects several headers depending of the client's IP:
  - `X-Geo-Location-Region`
  - `X-Geo-Location-City`
  - `X-Geo-Location-Coordinates`

You can also specify the path of a Maxmind GeoLite2-City database using the
`MAXMIND_CITY_DB_PATH` env var.

# Docs

## Create an account

By default no account is provisioned, you can either sign up using the website
(if your email adapter is configured) or create an account from Elixir's
interactive shell.

## Create a relay token

Firezone does not support per-account relays. Relays are global to the Firezone
installation.

Here is how you can generate a relay token:
```
import Portal.Authentication
{:ok, token} = create_relay_token()

encode_fragment!(token)
```
