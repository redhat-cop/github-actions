#!/usr/bin/env bats

@test "template.yml" {
  run conftest test confbatstest/_test/template.yml

  [ "$status" -eq 0 ]
}
