#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

cd "$WORK_DIR"
mkdir -p tests bin

cat > tests/"a safe test.sh" <<'TEST'
# safe
TEST

cat > tests/"polluting test.sh" <<'TEST'
# polluter
TEST

cat > bin/custom-runner <<'RUNNER'
#!/usr/bin/env bash
set -euo pipefail

echo "$1" >> runner.log
case "$1" in
  *"polluting test.sh")
    touch pollution.marker
    ;;
esac
RUNNER
chmod +x bin/custom-runner

set +e
"$ROOT_DIR/.vibe/skills/systematic-debugging/find-polluter.sh" \
  pollution.marker './tests/* test.sh' ./bin/custom-runner > output.log 2>&1
status=$?
set -e

if [ "$status" -ne 1 ]; then
  echo "Expected find-polluter.sh to exit 1 after finding polluter, got $status"
  cat output.log
  exit 1
fi

if ! grep -Fqx './tests/a safe test.sh' runner.log; then
  echo "Expected custom runner to receive filename with spaces as one argument"
  cat runner.log 2>/dev/null || true
  cat output.log
  exit 1
fi

if ! grep -Fqx './tests/polluting test.sh' runner.log; then
  echo "Expected custom runner to receive polluting filename with spaces as one argument"
  cat runner.log 2>/dev/null || true
  cat output.log
  exit 1
fi

if ! grep -Fq 'FOUND POLLUTER' output.log; then
  echo "Expected output to report polluter"
  cat output.log
  exit 1
fi
