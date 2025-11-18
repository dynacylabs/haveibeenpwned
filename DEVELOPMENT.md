# Development Guide

This guide covers the development workflow, testing, and release process for the Have I Been Pwned Python library.

## Table of Contents

- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Testing](#testing)
- [Code Coverage](#code-coverage)
- [Development Workflow](#development-workflow)
- [Release Process](#release-process)
- [Continuous Integration](#continuous-integration)
- [Debugging](#debugging)
- [Performance](#performance)

## Development Setup

### Prerequisites

- Python 3.8+
- Git
- pip
- (Optional) HIBP API key for integration tests

### Initial Setup

1. **Clone the Repository**

```bash
git clone https://github.com/dynacylabs/haveibeenpwned.git
cd haveibeenpwned
```

2. **Create Virtual Environment**

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install Development Dependencies**

```bash
# Install package in editable mode
pip install -e .

# Install test dependencies
pip install -r requirements-test.txt
```

4. **Verify Installation**

```bash
# Run unit tests
./run_tests.sh unit

# Check imports
python -c "from haveibeenpwned import HIBP; print('Success!')"
```

### IDE Setup

#### VS Code

Recommended extensions:
- Python (Microsoft)
- Pylance
- Python Test Explorer
- Coverage Gutters

Recommended settings (`.vscode/settings.json`):

```json
{
    "python.testing.pytestEnabled": true,
    "python.testing.unittestEnabled": false,
    "python.linting.enabled": true,
    "python.linting.pylintEnabled": true,
    "python.formatting.provider": "black",
    "python.analysis.typeCheckingMode": "basic"
}
```

#### PyCharm

1. Mark `haveibeenpwned/` as Sources Root
2. Enable pytest as test runner
3. Configure Python 3.8+ interpreter
4. Enable type checking

## Project Structure

```
haveibeenpwned/
├── haveibeenpwned/          # Main package
│   ├── __init__.py          # Package exports
│   ├── api.py               # Main HIBP interface
│   ├── breach.py            # Breach API endpoints
│   ├── client.py            # HTTP client
│   ├── exceptions.py        # Custom exceptions
│   ├── models.py            # Data models
│   ├── passwords.py         # Pwned Passwords API
│   ├── pastes.py            # Pastes API endpoints
│   ├── stealer_logs.py      # Stealer Logs API endpoints
│   └── subscription.py      # Subscription API endpoints
├── tests/                   # Test suite
│   ├── conftest.py          # Pytest configuration and fixtures
│   ├── test_api.py          # Main interface tests
│   ├── test_breach.py       # Breach endpoint tests
│   ├── test_client.py       # HTTP client tests
│   ├── test_models.py       # Data model tests
│   ├── test_other_endpoints.py  # Other endpoint tests
│   └── test_passwords.py    # Password endpoint tests
├── .github/
│   └── workflows/
│       ├── tests.yml              # Automated testing
│       ├── publish.yml            # PyPI publishing
│       ├── security.yml           # Security scanning
│       └── dependency-updates.yml # Dependency monitoring
├── setup.py                 # Package configuration
├── requirements.txt         # Runtime dependencies
├── requirements-test.txt    # Test dependencies
├── pytest.ini               # Pytest configuration
├── run_tests.sh             # Test runner script
├── release.sh               # Release automation script
├── README.md                # Project overview
├── INSTALL.md               # Installation guide
├── USAGE.md                 # Usage guide
├── CONTRIBUTING.md          # Contribution guidelines
└── DEVELOPMENT.md           # This file
```

### Key Files

#### `haveibeenpwned/__init__.py`

Exports public API:

```python
from .api import HIBP
from .exceptions import (
    HIBPError,
    NotFoundError,
    RateLimitError,
    # ... other exceptions
)
from .models import Breach, Paste, Subscription

__all__ = ["HIBP", "HIBPError", ...]
```

#### `setup.py`

Package metadata and dependencies:

```python
setup(
    name="haveibeenpwned-py",
    version="1.0.0",
    packages=find_packages(exclude=["tests*"]),
    install_requires=["requests>=2.25.0"],
    python_requires=">=3.8",
)
```

#### `pytest.ini`

Test configuration:

```ini
[pytest]
markers =
    unit: Unit tests (fast, mocked)
    integration: Integration tests (live API)
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
```

## Testing

### Test Types

#### Unit Tests (Mocked)

Fast tests with mocked HTTP responses:

```python
@pytest.mark.unit
def test_get_breaches(mock_client):
    """Test breach retrieval with mocked client."""
    mock_client.get.return_value = [{"Name": "Adobe"}]
    breaches = api.get_breaches_for_account("test@example.com")
    assert len(breaches) == 1
```

#### Integration Tests (Live API)

Tests against real HIBP API:

```python
@pytest.mark.integration
def test_get_breaches_live():
    """Test breach retrieval with live API."""
    hibp = HIBP(api_key=os.getenv("HIBP_API_KEY"))
    breaches = hibp.get_account_breaches(
        "account-exists@hibp-integration-tests.com"
    )
    assert len(breaches) > 0
```

### Running Tests

The `run_tests.sh` script provides convenient test execution:

```bash
# Run all tests (unit + integration)
./run_tests.sh all

# Run only unit tests (fast, no API key needed)
./run_tests.sh unit

# Run only integration tests (requires HIBP_API_KEY)
export HIBP_API_KEY="your-api-key-here"
./run_tests.sh live

# Run with coverage report
./run_tests.sh coverage

# Run specific test file
pytest tests/test_client.py

# Run specific test
pytest tests/test_client.py::test_get_request_success

# Run with verbose output
pytest -v

# Run with output from print statements
pytest -s

# Stop on first failure
pytest -x
```

### Test Fixtures

Common fixtures in `conftest.py`:

```python
@pytest.fixture
def mock_client():
    """Mock HTTP client for unit tests."""
    with patch('haveibeenpwned.client.APIClient') as mock:
        yield mock

@pytest.fixture
def hibp_test_key():
    """Test API key for integration tests."""
    return os.getenv("HIBP_API_KEY", "00000000000000000000000000000000")

@pytest.fixture
def hibp_client(hibp_test_key):
    """HIBP client with test API key."""
    return HIBP(api_key=hibp_test_key)
```

### Writing Tests

#### Test Structure

Use Arrange-Act-Assert pattern:

```python
def test_password_found_in_breaches():
    """Test password found returns correct count."""
    # Arrange
    hibp = HIBP()
    password = "password123"
    
    # Act
    count = hibp.is_password_pwned(password)
    
    # Assert
    assert count > 0
    assert isinstance(count, int)
```

#### Test Naming

Use descriptive names:

```python
# Good
def test_get_breaches_returns_list_when_found():
    pass

def test_get_breaches_raises_not_found_when_no_breaches():
    pass

# Bad
def test_breaches():
    pass

def test_1():
    pass
```

#### Parametrized Tests

Test multiple inputs efficiently:

```python
@pytest.mark.parametrize("password,expected", [
    ("password", True),
    ("P@ssw0rd!", True),
    ("veryuncommonpassword123xyz", False),
])
def test_password_pwned_various(password, expected):
    """Test various passwords."""
    hibp = HIBP()
    count = hibp.is_password_pwned(password)
    assert (count > 0) == expected
```

## Code Coverage

### Coverage Goals

- **Overall**: >95%
- **New code**: 100%
- **Critical paths**: 100%

### Measuring Coverage

```bash
# Generate coverage report
./run_tests.sh coverage

# View HTML report
open htmlcov/index.html  # macOS
xdg-open htmlcov/index.html  # Linux
start htmlcov/index.html  # Windows

# Coverage with terminal report
pytest --cov=haveibeenpwned --cov-report=term-missing

# Check coverage threshold
pytest --cov=haveibeenpwned --cov-fail-under=95
```

### Coverage Report

```
Name                         Stmts   Miss  Cover   Missing
----------------------------------------------------------
haveibeenpwned/__init__.py      12      0   100%
haveibeenpwned/api.py          145      3    98%   234-236
haveibeenpwned/breach.py       178      5    97%   156, 189-192
haveibeenpwned/client.py        89      2    98%   145-146
haveibeenpwned/exceptions.py    24      0   100%
haveibeenpwned/models.py        67      1    99%   123
haveibeenpwned/passwords.py     56      0   100%
haveibeenpwned/pastes.py        34      0   100%
haveibeenpwned/stealer_logs.py  45      2    96%   78-79
haveibeenpwned/subscription.py  28      0   100%
----------------------------------------------------------
TOTAL                          678     13    98%
```

### Improving Coverage

1. **Find uncovered lines**:
   ```bash
   pytest --cov=haveibeenpwned --cov-report=term-missing
   ```

2. **Add tests for missing lines**:
   ```python
   # Cover error handling
   def test_error_path():
       with pytest.raises(HIBPError):
           # trigger error condition
   ```

3. **Test edge cases**:
   ```python
   def test_empty_response():
       # Test with empty data
   
   def test_malformed_response():
       # Test with invalid data
   ```

## Development Workflow

### Typical Development Cycle

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/new-endpoint
   ```

2. **Write Failing Test**
   ```python
   def test_new_endpoint():
       result = hibp.new_endpoint()
       assert result is not None
   ```

3. **Implement Feature**
   ```python
   def new_endpoint(self):
       return self.client.get("/new-endpoint")
   ```

4. **Run Tests**
   ```bash
   ./run_tests.sh unit
   ```

5. **Fix Issues, Repeat**

6. **Check Coverage**
   ```bash
   ./run_tests.sh coverage
   ```

7. **Integration Test**
   ```bash
   export HIBP_API_KEY="your-key"
   ./run_tests.sh live
   ```

8. **Commit and Push**
   ```bash
   git add .
   git commit -m "Add new endpoint support"
   git push origin feature/new-endpoint
   ```

### Code Review Checklist

Before requesting review:

- [ ] All tests pass
- [ ] Coverage >95%
- [ ] Type hints added
- [ ] Docstrings added
- [ ] Documentation updated
- [ ] No linting errors
- [ ] Commit messages clear
- [ ] Branch up to date with main

## Release Process

### Version Numbering

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (1.0.0 → 2.0.0): Breaking changes
- **MINOR** (1.0.0 → 1.1.0): New features, backward compatible
- **PATCH** (1.0.0 → 1.0.1): Bug fixes, backward compatible

### Automated Release

Use the `release.sh` script for automated releases:

```bash
# Release new version
./release.sh 1.2.3
```

This script:
1. Updates version in `setup.py`
2. Commits the change
3. Creates a git tag
4. Pushes to GitHub
5. Triggers GitHub Actions to publish to PyPI

### Manual Release Steps

If you prefer manual release:

1. **Update Version**
   ```python
   # In setup.py
   version="1.2.3"
   ```

2. **Commit Changes**
   ```bash
   git add setup.py
   git commit -m "Bump version to 1.2.3"
   ```

3. **Create Tag**
   ```bash
   git tag -a v1.2.3 -m "Release 1.2.3"
   ```

4. **Push to GitHub**
   ```bash
   git push origin main --tags
   ```

5. **Create GitHub Release**
   - Go to GitHub Releases
   - Click "Create a new release"
   - Select the tag
   - Add release notes
   - Publish release

6. **GitHub Actions publishes to PyPI automatically**

### PyPI Trusted Publishing Setup

For first-time PyPI publishing, configure Trusted Publishing:

1. **Create PyPI Account**: https://pypi.org/account/register/
2. **Enable 2FA**: https://pypi.org/manage/account/
3. **Set up Trusted Publishing**:
   - Go to: https://pypi.org/manage/account/publishing/
   - Add publisher:
     - PyPI Project Name: `haveibeenpwned-py`
     - Owner: `dynacylabs`
     - Repository: `haveibeenpwned`
     - Workflow: `publish.yml`
     - Environment: `pypi`

4. **Configure GitHub Environment**:
   - Go to: Repo → Settings → Environments
   - Create environment: `pypi`
   - Add required reviewers
   - Save protection rules

### Release Checklist

Before releasing:

- [ ] All tests pass on CI
- [ ] Coverage >95%
- [ ] Documentation up to date
- [ ] CHANGELOG prepared
- [ ] Version number updated
- [ ] No uncommitted changes
- [ ] Branch synced with main

## Continuous Integration

### GitHub Actions Workflows

#### Tests (`tests.yml`)

Runs on every push and PR:
- Tests on Python 3.8, 3.9, 3.10, 3.11
- Unit tests (fast)
- Integration tests (with API key)
- Coverage report

#### Publish (`publish.yml`)

Runs on GitHub releases:
- Builds package
- Runs tests
- Publishes to PyPI (with approval)

#### Security (`security.yml`)

Regular security scans:
- Dependency vulnerabilities
- Code security issues
- License compliance

### Local CI Simulation

Test like CI does:

```bash
# Test multiple Python versions with tox
tox

# Or manually with different Python versions
python3.8 -m pytest
python3.9 -m pytest
python3.10 -m pytest
```

## Debugging

### Debug Logging

Enable debug logging:

```python
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger("haveibeenpwned")
logger.setLevel(logging.DEBUG)

hibp = HIBP(api_key="...")
breaches = hibp.get_account_breaches("test@example.com")
```

### Interactive Debugging

Use Python debugger:

```python
import pdb

def get_breaches(account):
    pdb.set_trace()  # Breakpoint here
    response = self.client.get(f"/breachedaccount/{account}")
    return response
```

Or with pytest:

```bash
# Drop into debugger on test failure
pytest --pdb

# Drop into debugger on all tests
pytest --trace
```

### VS Code Debugging

`.vscode/launch.json`:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Current File",
            "type": "python",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal"
        },
        {
            "name": "Python: Pytest",
            "type": "python",
            "request": "launch",
            "module": "pytest",
            "args": ["-v", "${file}"]
        }
    ]
}
```

## Performance

### Profiling

Profile your code:

```python
import cProfile
import pstats

def profile_function():
    hibp = HIBP(api_key="...")
    for i in range(100):
        hibp.is_password_pwned(f"password{i}")

# Profile and save results
cProfile.run("profile_function()", "profile_stats")

# View results
stats = pstats.Stats("profile_stats")
stats.sort_stats("cumulative")
stats.print_stats(10)
```

### Memory Usage

Check memory usage:

```python
from memory_profiler import profile

@profile
def memory_intensive_function():
    hibp = HIBP(api_key="...")
    all_breaches = hibp.get_all_breaches()
    # Process breaches
```

### Optimization Tips

1. **Reuse client instances**: Create HIBP once, reuse it
2. **Batch operations**: Group API calls when possible
3. **Cache results**: Store frequently accessed data
4. **Use generators**: For large datasets
5. **Respect rate limits**: Avoid unnecessary retries

## Additional Resources

- [Installation Guide](INSTALL.md)
- [Usage Guide](USAGE.md)
- [Contributing Guide](CONTRIBUTING.md)
- [HIBP API Docs](https://haveibeenpwned.com/API/v3)
- [Python Packaging Guide](https://packaging.python.org/)
- [Pytest Documentation](https://docs.pytest.org/)
