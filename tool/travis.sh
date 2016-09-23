#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings \
  lib/bootstrap.dart \
  lib/bootstrap_class_loader.dart \
  lib/bootstrap_loader.dart \

pub run test -p vm,firefox