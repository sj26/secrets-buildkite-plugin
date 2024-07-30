# Cluster Secrets Buildkite Plugin

A Buildkite plugin used to fetch secrets from [Buildkite Secrets](https://buildkite.com/docs/pipelines/buildkite-secrets),

## Storing Secrets
The plugin expects that secrets will be stored base64 encoded in a secret with the key "env", in the format KEY=value in Buildkite secrets:

```shell
Foo=bar
SECRET_KEY=llamas
COFFEE=more
```

You can create a secret in your Buildkite cluster(s) from the Buildkite UI following the instructions in the documentation [here](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets#create-a-secret-using-the-buildkite-interface).

## Examples

### Default Configuration
Add the plugin to your pipeline YAML to download. By default the plugin will fetch the secret with key `env`

```yaml
steps:
    - command: build.sh
      plugins:
        - cluster-secrets#v0.1.0
```

### Custom Secret Key
Alernatively, you can specify a custom key that will be fetched by the plugin, instead of the default `env`

```yaml
steps:
    - command: build.sh
      plugins:
        - cluster-secrets#v0.1.0:
            key: "llamas"
```

### Options
Currently, the plugin supports a single configurable option
#### `key` (optional, string)
The key to fetch from Buildkite secrets, see [example](#custom-secret-key)

## Testing
You can run the tests using `docker-compose`:
```bash
docker compose run --rm tests
```

## License

MIT (see [LICENSE](LICENSE))
