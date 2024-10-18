#!/usr/bin/env bats

export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty

setup() {
  load "${BATS_PLUGIN_PATH}/load.bash"

  export BUILDKITE_PIPELINE_SLUG=testpipe
  export BUILDKITE_PLUGIN_CLUSTER_SECRETS_DUMP_ENV=true
}

@test "Download default env from Buildkite secrets" {
    export TESTDATA="Rk9PPWJhcgpCQVI9QmF6ClNFQ1JFVD1sbGFtYXMK"

    stub buildkite-agent "secret get env : echo ${TESTDATA}"

    run bash -c "$PWD/hooks/environment"

    assert_success
    assert_output --partial "FOO=bar"
    refute_output --partial "blah=blah"
}

@test "Download custom env from Buildkite secrets" {
    export TESTDATA='Rk9PPWJhcgpCQVI9QmF6ClNFQ1JFVD1sbGFtYXMK'
    export BUILDKITE_PLUGIN_CLUSTER_SECRETS_ENV="llamas"

    stub buildkite-agent "secret get llamas : echo ${TESTDATA}"

    run bash -c "$PWD/hooks/environment"

    assert_success
    assert_output --partial "FOO=bar"
}


@test "Download single variable from Buildkite secrets" {
    export TESTDATA='Rk9PPWJhcgpCQVI9QmF6ClNFQ1JFVD1sbGFtYXMK'
    export BUILDKITE_PLUGIN_CLUSTER_SECRETS_VARIABLES_0="ANIMAL"
    
    stub buildkite-agent \
        "secret get env : echo ${TESTDATA}" \
        "secret get ANIMAL : echo llama"

    run bash -c "$PWD/hooks/environment"

    assert_success
    assert_output --partial "ANIMAL=llama"
    unstub buildkite-agent
}

@test "Download multiple variables from Buildkite secrets" {
    export TESTDATA='Rk9PPWJhcgpCQVI9QmF6ClNFQ1JFVD1sbGFtYXMK'
    export BUILDKITE_PLUGIN_CLUSTER_SECRETS_VARIABLES_0="ANIMAL"
    export BUILDKITE_PLUGIN_CLUSTER_SECRETS_VARIABLES_1="COUNTRY"
    export BUILDKITE_PLUGIN_CLUSTER_SECRETS_VARIABLES_2="FOOD"
    
    stub buildkite-agent \
        "secret get env : echo ${TESTDATA}" \
        "secret get ANIMAL : echo llama" \
        "secret get COUNTRY : echo Canada" \
        "secret get FOOD : echo Poutine"

    run bash -c "$PWD/hooks/environment"

    assert_success
    assert_output --partial "ANIMAL=llama"
    assert_output --partial "COUNTRY=Canada"
    assert_output --partial "FOOD=Poutine"
    unstub buildkite-agent
}

@test "If no key env found in Buildkite secrets the plugin does nothing - but doesn't fail" {
   
    stub buildkite-agent "secret get env : echo 'not found'"

    run bash -c "$PWD/hooks/environment"

    assert_success
    assert_output --partial "Unable to find secret at"
    unstub buildkite-agent
}

@test "If no custom key found in Buildkite secrets the plugin does nothing - but doesn't fail" {
    export BUILDKITE_PLUGIN_CLUSTER_SECRETS_ENV="llamas"
   
    stub buildkite-agent "secret get llamas : echo 'not found'"

    run bash -c "$PWD/hooks/environment"

    assert_success
    assert_output --partial "Unable to find secret at"
    unstub buildkite-agent
}