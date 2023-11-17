#!/usr/bin/env bats

setup() {    
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  PROJECT_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )/.." >/dev/null 2>&1 && pwd )"

}

@test "install packages" {
  run install_packages
  [ "$status" -eq 0 ]
}

@test "install yay" {
  result=$(install_yay)
  [ "$status" -eq 0 ]
}
