#!/usr/bin/env bash
# Bisection script to find which test creates unwanted files/state
# Usage: ./find-polluter.sh <file_or_dir_to_check> <test_pattern> [test_command]
# Example: ./find-polluter.sh '.git' 'src/**/*.test.ts'
# Example: ./find-polluter.sh '.git' 'src/**/*.test.ts' 'pnpm test'

set -e

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "Usage: $0 <file_to_check> <test_pattern> [test_command]"
  echo "Example: $0 '.git' 'src/**/*.test.ts'"
  echo "Example: $0 '.git' 'src/**/*.test.ts' 'pnpm test'"
  exit 1
fi

POLLUTION_CHECK="$1"
TEST_PATTERN="$2"
TEST_CMD="${3:-npm test}"
TEST_FILES_LIST=$(mktemp)
trap 'rm -f "$TEST_FILES_LIST"' EXIT

echo "🔍 Searching for test that creates: $POLLUTION_CHECK"
echo "Test pattern: $TEST_PATTERN"
echo "Test command: $TEST_CMD"
echo ""

# Get list of test files
find . -path "$TEST_PATTERN" | sort > "$TEST_FILES_LIST"
TOTAL=$(wc -l < "$TEST_FILES_LIST" | tr -d ' ')

echo "Found $TOTAL test files"
echo ""

COUNT=0
while IFS= read -r TEST_FILE; do
  COUNT=$((COUNT + 1))

  # Skip if pollution already exists
  if [ -e "$POLLUTION_CHECK" ]; then
    echo "⚠️  Pollution already exists before test $COUNT/$TOTAL"
    echo "   Skipping: $TEST_FILE"
    continue
  fi

  echo "[$COUNT/$TOTAL] Testing: $TEST_FILE"

  # Run the test
  # Intentionally allow TEST_CMD to split so callers can pass commands with arguments.
  # shellcheck disable=SC2086
  $TEST_CMD "$TEST_FILE" > /dev/null 2>&1 || true

  # Check if pollution appeared
  if [ -e "$POLLUTION_CHECK" ]; then
    echo ""
    echo "🎯 FOUND POLLUTER!"
    echo "   Test: $TEST_FILE"
    echo "   Created: $POLLUTION_CHECK"
    echo ""
    echo "Pollution details:"
    ls -la "$POLLUTION_CHECK"
    echo ""
    echo "To investigate:"
    echo "  $TEST_CMD $TEST_FILE    # Run just this test"
    echo "  cat $TEST_FILE         # Review test code"
    exit 1
  fi
done < "$TEST_FILES_LIST"

echo ""
echo "✅ No polluter found - all tests clean!"
exit 0
