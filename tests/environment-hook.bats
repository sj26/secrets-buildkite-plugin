#!/usr/bin/env bats

# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty

setup() {
  load "${BATS_PLUGIN_PATH}/load.bash"

  export BUILDKITE_PIPELINE_SLUG=testpipe
  export BUILDKITE_PLUGIN_CLUSTER_SECRETS_DUMP_ENV=true
}

@test "Load default env from Buildkite secrets" {
    export TESTDATA='Rk9PPWJhcgpCQVI9QmF6ClNFQ1JFVD1sbGFtYXMK'

    stub buildkite-agent "secret get env : echo ${TESTDATA}"

    run bash -c "$PWD/hooks/environment"

    assert_success
}

@test "Load env from custom key from Buildkite secrets" {
    export TESTDATA='Rk9PPWJhcgpCQVI9QmF6ClNFQ1JFVD1sbGFtYXMK'
    export BUILDKITE_PLUGIN_CLUSTER_SECRETS_KEY="llamas"

    stub buildkite-agent "secret get llamas : echo ${TESTDATA}"

    run bash -c "$PWD/hooks/environment"

    assert_success
    assert_output --partial "FOO=bar"

}

@test "If no key env found in Buildkite secrets the plugin fails" {
   
    stub buildkite-agent "secret get env : exit 1"

    run bash -c "$PWD/hooks/environment"

    assert_failure
}

@test "If no custom key found in Buildkite secrets the plugin fails" {
    export BUILDKITE_PLUGIN_CLUSTER_SECRETS_KEY="llamas"
   
    stub buildkite-agent "secret get llamas : exit 1"

    run bash -c "$PWD/hooks/environment"

    assert_failure
}