#!/bin/bash
set -eux

mkdir -p .config
tee .config/nextest.toml << END
[store]
dir = "target/nextest"
[profile.ci]
retries = 0
test-threads = "num-cpus"
status-level = "pass"
final-status-level = "none"
slow-timeout = { period = "30s" }
leak-timeout = "100ms"
failure-output = "immediate-final"
fail-fast = false

[profile.ci.junit]
path = "junit.xml"
report-name = "nextest-run"
END

cargo-nextest nextest run --partition "count:$((CIRCLE_NODE_INDEX + 1))/${CIRCLE_NODE_TOTAL}" --archive-file="${ARCHIVE}" --profile ci
mkdir test-results 
circleci-junit-fix > test-results/junit.xml < target/nextest/ci/junit.xml
