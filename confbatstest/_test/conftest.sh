#!/usr/bin/env bats

@test "template.yml" {
  run conftest test confbatstest/_test/template.yml --rego-version v0

  [ "$status" -eq 0 ]
}
