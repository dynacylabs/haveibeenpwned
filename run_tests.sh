#!/bin/bash
#
# Test runner script for the hibp library.
#
# Usage:
#     ./run_tests.sh              # Run all tests
#     ./run_tests.sh unit         # Run only unit tests (mocked, fast)
#     ./run_tests.sh live         # Run only live/integration tests
#     ./run_tests.sh coverage     # Run with coverage report
#     ./run_tests.sh quick        # Run unit tests only (same as 'unit')
#     ./run_tests.sh <file>       # Run specific test file
#     ./run_tests.sh --help       # Show this help

set -e

print_header() {
    echo ""
    echo "======================================================================"
    echo "  $1"
    echo "======================================================================"
    echo ""
}

# Parse arguments
MODE="${1:-all}"

if [[ "$MODE" == "--help" || "$MODE" == "-h" || "$MODE" == "help" ]]; then
    sed -n '2,12p' "$0" | sed 's/^# //'
    exit 0
fi

# Check if pytest is installed
if ! command -v pytest &> /dev/null; then
    echo "❌ pytest is not installed!"
    echo ""
    echo "Install dependencies:"
    echo "  pip install -r requirements.txt"
    exit 1
fi

# Check for API key (for live tests)
if [[ -n "$HIBP_API_KEY" && "$HIBP_API_KEY" != "00000000000000000000000000000000" ]]; then
    HAS_API_KEY=true
else
    HAS_API_KEY=false
fi

# Build pytest command based on mode
case "$MODE" in
    unit|mock|mocked|quick)
        print_header "Running Unit Tests (Mocked)"
        pytest -m unit -v
        ;;
    
    live|integration|int)
        print_header "Running Integration Tests (Live API)"
        if [[ "$HAS_API_KEY" == "false" ]]; then
            echo "⚠️  Warning: No HIBP_API_KEY set. Some tests will be skipped."
            echo "Set API key: export HIBP_API_KEY='your-api-key'"
            echo ""
        fi
        pytest -m integration -v
        ;;
    
    coverage|cov)
        print_header "Running All Tests with Coverage"
        if [[ "$HAS_API_KEY" == "false" ]]; then
            echo "⚠️  Note: Integration tests will be skipped without HIBP_API_KEY"
            echo ""
        fi
        pytest -v --cov=hibp --cov-report=term-missing --cov-report=html
        ;;
    
    all)
        print_header "Running All Tests"
        if [[ "$HAS_API_KEY" == "false" ]]; then
            echo "⚠️  Note: Integration tests will be skipped without HIBP_API_KEY"
            echo ""
        fi
        pytest -v
        ;;
    
    test_*|*.py)
        print_header "Running Specific Test: $MODE"
        TEST_FILE="tests/$MODE"
        [[ ! "$MODE" =~ ^tests/ ]] || TEST_FILE="$MODE"
        [[ "$TEST_FILE" =~ \.py$ ]] || TEST_FILE="${TEST_FILE}.py"
        pytest "$TEST_FILE" -v
        ;;
    
    *)
        echo "❌ Unknown mode: $MODE"
        echo ""
        echo "Valid modes: unit, live, coverage, all, quick, or a test file name"
        echo "Run './run_tests.sh --help' for more information"
        exit 1
        ;;
esac

EXIT_CODE=$?

# Print summary
echo ""
echo "======================================================================"
if [[ $EXIT_CODE -eq 0 ]]; then
    echo "✅ All tests passed!"
else
    echo "❌ Tests failed with exit code $EXIT_CODE"
fi

if [[ "$MODE" == "coverage" || "$MODE" == "cov" ]]; then
    echo ""
    echo "📊 Coverage report generated: htmlcov/index.html"
fi

echo "======================================================================"
echo ""

exit $EXIT_CODE
