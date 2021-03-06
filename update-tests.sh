#!/bin/bash
set -o errexit
node_modules/.bin/tsc
set +o errexit

for test in $(find tests -name '*.ts'); do
  echo $test
  node dist/index.js $test > $test.out 2>&1
  rc=${PIPESTATUS[0]}; if [[ $rc != 0 ]]; then exit $rc; fi
done

# test wrong file path
node dist/index.js doesnt_exist.ts > doesnt_exist.ts.out 2>&1

# This shows changes and sets the exit code.
set -o errexit
git status
git --no-pager diff -- tests
