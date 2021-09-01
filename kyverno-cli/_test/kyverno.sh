#!/usr/bin/env bats

@test "namespace.yaml" {
  run kyverno apply kyverno-cli/_test/policy.yaml --resource kyverno-cli/_test/namespace.yaml

  [ "$status" -eq 0 ]
}