# Secrets Buildkite Plugin

A Buildkite plugin used to fetch secrets from [Buildkite Secrets](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets),

## Usage

You can create a secret in your Buildkite cluster(s) from the Buildkite UI following the instructions in the documentation [here](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets#create-a-secret-using-the-buildkite-interface).

Then use them in your pipeline:

```yml
steps:
  - command: echo "The content of ANIMAL is \$ANIMAL"
    plugins:
      sj26/secrets:
        env:
          - ANIMAL
```

## License

MIT (see [LICENSE](LICENSE))
