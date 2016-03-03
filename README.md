# NioDokku

NioDokku is a loose wrapper to control Dokku via SSH. Currently the library
requires the use of the `root` account to control Dokku via the command line. The
reason being that `plugin:*` commands requires root access. Additionally the
library requires access to a password-less ssh key pair with the public key installed
on the destination host. This is defined via config:

`config :nio_dokku, ssh_key_path: "keys/"`

Early days yet.

## Installation
Add `nio_dokku` to your list of dependencies in `mix.exs`:
```
def deps do
[{:nio_dokku, github: "maxneuvians/nio_dokku"}]
end
```

## Usage

Here is an example pipe flow:

```
import NioDokku

dokku "1.2.3.4"
|> dokku "apps:create test"
|> dokku "plugin:install https://github.com/dokku/dokku-postgres.git"
|> dokku "postgres:create test_db"
|> dokku "postgres:link test_db test"
|> dokku! "apps:destroy test"

```

Would return:

`["Destroying test (including all add-ons)"]`

The library also includes a function call: `available_commands/1` which takes the
`PID` and returns a list of available local commands for Dokku. Ex:

```
dokku "1.2.3.4"
|> available_commands
```

will spit out something like this:

```
["apps:create", "apps:destroy", "apps", "apps:rename", "backup:export",
 "backup:import", "certs:add", "certs:chain", "certs:generate", "certs:info",
 "certs:key", "certs:remove", "certs:rollback", "certs:update", "config",
 "config:get", "config:set", "config:unset", "docker-options:add",
 "docker-options", "docker-options", "docker-options:remove", "domains:add",
 "domains", "domains:clear", "domains:remove", "enter", "events:list",
 "events:off", "events:on", "events", "letsencrypt", "letsencrypt:auto-renew",
 "letsencrypt:auto-renew", "letsencrypt:ls", "letsencrypt:revoke", "logs", "ls",
 "nginx:access-logs", "nginx:build-config", "nginx:disable", "nginx:enable",
 "nginx:error-logs", "plugin:disable", "plugin:enable", "plugin:install",
 "plugin:install-dependencies", "plugin", "plugin:uninstall", "plugin:update",
 ...]
```
### Version
0.0.3

License
----
MIT
