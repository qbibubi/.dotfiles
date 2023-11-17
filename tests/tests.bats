#!/usr/bin/env bats

setup() {    
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  PROJECT_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )/.." >/dev/null 2>&1 && pwd )"
  SCRIPT_FILE="$("$HOME"/install.sh)"
}

@test "install packages" {
  run install_packages
  [ "$status" -eq 0 ]
}

@test "install yay" {
  result=$(install_yay)
  [ "$status" -eq 0 ]
}

@test "install zsh autosuggestions" {
  result=$(install_zsh_autosuggestions)
  [ "$status" -eq 0 ]
}

@test "setup shell" {
  result=$(setup_shell)
  [ "$status" -eq 0 ]
}

@test "setup ly" {
  result=$(setup_ly)
  [ "$status" -eq 0 ]
}
