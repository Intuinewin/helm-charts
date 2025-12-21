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

# Docs

# Create an account

By default no account is provisioned, you can either sign up using the website
(if your email adapter is configured) or create an account from Elixir's
interactive shell.

# Create a relay token

Firezone does not support per-account relays. Relays are global to the Firezone
installation.

Here is how you can generate a relay token:
```
import Domain.Auth
{:ok, token} = create_relay_token()

encode_fragment!(token)
```

# User pass auth provider

Currently you can't create a userpass provider from the UI. However, It can be
useful for testing.

From an IEX shell

```
slug = "YOUR_ACCOUNT_SLUG"
name = "My User pass provider"

import Ecto.Query
alias Domain.Account
alias Domain.Safe
alias Domain.AuthProvider
alias Domain.Userpass
alias Domain.Repo

account = from(a in Account, where: a.slug == ^slug) \
  |> Safe.unscoped() \
  |> Safe.one!()

provider_module=Userpass.AuthProvider
provider_id = Ecto.UUID.generate()
type = AuthProvider.type!(Userpass.AuthProvider)
# Convert type to atom if it's a string
type = if is_binary(type), do: String.to_existing_atom(type), else: type

{:ok, _base_provider} = \
  Repo.insert(%AuthProvider{ \
    id: provider_id, \
    account_id: account.id, \
    type: type \
  })

# Then create the provider-specific record using Repo directly (seeds don't need authorization)
attrs_with_id = %{name: name} \
  |> Map.put(:id, provider_id) \
  |> Map.put(:account_id, account.id)

changeset = struct(provider_module, attrs_with_id) |> Ecto.Changeset.change()

Repo.insert(changeset)
```
