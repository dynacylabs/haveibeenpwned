# Contributing to Have I Been Pwned Python Library

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Code Quality Standards](#code-quality-standards)
- [Testing Requirements](#testing-requirements)
- [Pull Request Process](#pull-request-process)
- [Style Guide](#style-guide)
- [Documentation](#documentation)
- [Community](#community)

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of background or experience level.

### Expected Behavior

- Be respectful and considerate
- Welcome newcomers and help them get started
- Focus on constructive feedback
- Be patient with questions and discussions

### Unacceptable Behavior

- Harassment or discrimination of any kind
- Trolling, insulting, or derogatory comments
- Publishing others' private information
- Any conduct inappropriate for a professional setting

## Getting Started

### Prerequisites

Before contributing, ensure you have:

- Python 3.8 or higher installed
- Git installed and configured
- A GitHub account
- (Optional) An HIBP API key for integration testing

### First-Time Contributors

If this is your first contribution:

1. **Find an Issue**: Look for issues labeled `good first issue` or `help wanted`
2. **Ask Questions**: Don't hesitate to ask for clarification in the issue comments
3. **Small Changes**: Start with small, manageable changes
4. **Read the Docs**: Familiarize yourself with the [Usage Guide](USAGE.md)

## Development Setup

See the [Development Guide](DEVELOPMENT.md) for detailed setup instructions.

Quick setup:

```bash
# Clone the repository
git clone https://github.com/dynacylabs/haveibeenpwned.git
cd haveibeenpwned

# Install in development mode
pip install -e .

# Install development dependencies
pip install -r requirements-test.txt

# Run tests to verify setup
./run_tests.sh unit
```

## How to Contribute

### Types of Contributions

We welcome various types of contributions:

- **Bug Fixes**: Fix issues reported in the issue tracker
- **New Features**: Add new functionality or API endpoints
- **Documentation**: Improve docs, add examples, fix typos
- **Tests**: Add test coverage, improve test quality
- **Performance**: Optimize code for better performance
- **Refactoring**: Improve code structure and readability

### Reporting Bugs

When reporting bugs, include:

- **Clear Title**: Descriptive summary of the issue
- **Description**: Detailed explanation of the problem
- **Steps to Reproduce**: Exact steps to reproduce the issue
- **Expected Behavior**: What you expected to happen
- **Actual Behavior**: What actually happened
- **Environment**: Python version, OS, library version
- **Code Sample**: Minimal code to reproduce the issue

Example:

```markdown
### Bug: RateLimitError not handling retry_after correctly

**Description**: The RateLimitError exception doesn't properly parse the retry_after header.

**Steps to Reproduce**:
1. Make multiple rapid requests
2. Trigger rate limit error
3. Check retry_after value

**Expected**: retry_after should be an integer
**Actual**: retry_after is None

**Environment**:
- Python 3.9
- haveibeenpwned-py 1.0.0
- Ubuntu 22.04

**Code**:
\`\`\`python
hibp = HIBP(api_key="...")
try:
    for i in range(100):
        hibp.get_account_breaches(f"test{i}@example.com")
except RateLimitError as e:
    print(e.retry_after)  # Prints None instead of seconds
\`\`\`
```

### Suggesting Features

When suggesting features:

- **Check Existing Issues**: Ensure it hasn't been suggested
- **Use Case**: Explain why this feature is needed
- **API Compatibility**: Ensure it aligns with HIBP API
- **Implementation Ideas**: Suggest how it might work
- **Breaking Changes**: Note if it would break existing code

### Pull Request Process

1. **Fork the Repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/your-username/haveibeenpwned.git
   cd haveibeenpwned
   git remote add upstream https://github.com/dynacylabs/haveibeenpwned.git
   ```

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/my-new-feature
   # or
   git checkout -b fix/bug-description
   ```

3. **Make Your Changes**
   - Write clear, readable code
   - Follow the style guide
   - Add tests for new functionality
   - Update documentation as needed

4. **Test Your Changes**
   ```bash
   # Run all tests
   ./run_tests.sh all
   
   # Check coverage (must be >95%)
   ./run_tests.sh coverage
   
   # Run type checking
   mypy haveibeenpwned/
   ```

5. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Add feature: description of changes"
   ```

   Use clear commit messages:
   - `Add feature: ...` for new features
   - `Fix: ...` for bug fixes
   - `Docs: ...` for documentation changes
   - `Test: ...` for test additions/changes
   - `Refactor: ...` for code refactoring

6. **Push to Your Fork**
   ```bash
   git push origin feature/my-new-feature
   ```

7. **Create Pull Request**
   - Go to GitHub and create a pull request
   - Fill out the PR template completely
   - Link any related issues
   - Wait for review

## Code Quality Standards

All contributions must meet these standards:

### Testing Requirements

- ✅ **All tests must pass**: Run `./run_tests.sh all`
- ✅ **Coverage must be >95%**: Run `./run_tests.sh coverage`
- ✅ **New features need tests**: Both unit and integration tests
- ✅ **Fix broken tests**: Don't comment out failing tests

### Code Style

- ✅ **Follow PEP 8**: Use Python style conventions
- ✅ **Type hints**: Add type hints to all functions
- ✅ **Docstrings**: Document all public functions and classes
- ✅ **Clear naming**: Use descriptive variable and function names

### Documentation

- ✅ **Update docs**: Keep README and guides up to date
- ✅ **Add examples**: Include usage examples for new features
- ✅ **Comment complex code**: Explain non-obvious logic
- ✅ **API docs**: Document all public APIs

### Performance

- ✅ **No unnecessary imports**: Import only what you need
- ✅ **Efficient algorithms**: Use appropriate data structures
- ✅ **Minimize API calls**: Batch operations when possible
- ✅ **Handle large responses**: Consider memory usage

## Testing Requirements

### Test Coverage Goals

- **Overall coverage**: >95%
- **New code coverage**: 100%
- **Branch coverage**: >90%

### Types of Tests

#### Unit Tests (Mocked)

Fast tests that don't make real API calls:

```python
def test_get_breaches_success(mock_client):
    """Test getting breaches with mocked response."""
    mock_client.get.return_value = [{"Name": "Adobe", ...}]
    breaches = api.get_breaches_for_account("test@example.com")
    assert len(breaches) == 1
    assert breaches[0].name == "Adobe"
```

#### Integration Tests (Live API)

Tests that make real API calls:

```python
@pytest.mark.integration
def test_get_breaches_live():
    """Test getting breaches with live API."""
    hibp = HIBP(api_key=os.getenv("HIBP_API_KEY"))
    breaches = hibp.get_account_breaches(
        "account-exists@hibp-integration-tests.com"
    )
    assert len(breaches) > 0
```

### Running Tests

```bash
# Run all tests
./run_tests.sh all

# Run only unit tests (fast, no API key)
./run_tests.sh unit

# Run only integration tests (requires HIBP_API_KEY)
export HIBP_API_KEY="your-api-key"
./run_tests.sh live

# Run with coverage
./run_tests.sh coverage

# Run specific test file
pytest tests/test_client.py

# Run specific test
pytest tests/test_client.py::test_get_breaches_success
```

### Writing Good Tests

1. **Test One Thing**: Each test should verify one behavior
2. **Clear Names**: Test names should describe what they test
3. **Arrange-Act-Assert**: Structure tests clearly
4. **Use Fixtures**: Reuse common setup code
5. **Mock External Calls**: Don't depend on external services in unit tests

Example:

```python
def test_password_pwned_found(mock_passwords_api):
    """Test password found in breaches returns count."""
    # Arrange
    mock_passwords_api.search_by_hash.return_value = {"ABC": 5}
    
    # Act
    count = hibp.is_password_pwned("password123")
    
    # Assert
    assert count == 5
```

## Style Guide

### Python Style

Follow [PEP 8](https://pep8.org/) with these specifics:

#### Naming Conventions

```python
# Classes: PascalCase
class BreachClient:
    pass

# Functions and variables: snake_case
def get_account_breaches():
    user_email = "test@example.com"

# Constants: UPPER_SNAKE_CASE
DEFAULT_TIMEOUT = 30
API_BASE_URL = "https://haveibeenpwned.com/api/v3"

# Private methods: _leading_underscore
def _make_request():
    pass
```

#### Type Hints

Always include type hints:

```python
from typing import List, Optional, Dict

def get_breaches(
    account: str,
    truncate: bool = True,
    domain: Optional[str] = None
) -> List[Breach]:
    """Get breaches for an account."""
    pass
```

#### Docstrings

Use Google-style docstrings:

```python
def get_account_breaches(
    account: str,
    truncate_response: bool = True,
    domain: Optional[str] = None,
    include_unverified: bool = True
) -> List[Breach]:
    """Get all breaches for an account.

    Args:
        account: The email address to check.
        truncate_response: Return only breach name if True.
        domain: Filter results by domain.
        include_unverified: Include unverified breaches.

    Returns:
        List of Breach objects.

    Raises:
        NotFoundError: If no breaches found.
        RateLimitError: If rate limit exceeded.
        HIBPError: For other API errors.

    Example:
        >>> hibp = HIBP(api_key="...")
        >>> breaches = hibp.get_account_breaches("test@example.com")
        >>> print(f"Found {len(breaches)} breaches")
    """
    pass
```

#### Code Organization

```python
# 1. Standard library imports
import os
from typing import List, Optional

# 2. Third-party imports
import requests

# 3. Local imports
from .models import Breach
from .exceptions import HIBPError

# 4. Constants
DEFAULT_TIMEOUT = 30

# 5. Classes and functions
class BreachClient:
    pass
```

## Documentation

### When to Update Documentation

Update documentation when you:

- Add new features or functionality
- Change existing behavior
- Fix bugs that affect usage
- Add new configuration options
- Change API signatures

### What to Document

- **README.md**: Keep overview current
- **USAGE.md**: Add usage examples for new features
- **INSTALL.md**: Update installation steps if needed
- **DEVELOPMENT.md**: Update development setup if changed
- **Docstrings**: Document all public APIs
- **Comments**: Explain complex or non-obvious code

### Documentation Style

- Use clear, simple language
- Include code examples
- Show both simple and advanced usage
- Document edge cases and limitations
- Keep examples up-to-date

## Community

### Getting Help

- **Issues**: Ask questions in GitHub issues
- **Discussions**: Use GitHub discussions for general topics
- **Email**: Contact maintainers for private matters

### Maintainer Response Time

- Bug reports: 2-3 business days
- Feature requests: 1 week
- Pull requests: 3-5 business days

### Recognition

Contributors are recognized in:
- GitHub contributors list
- Release notes
- Project README (for significant contributions)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Questions?

If you have questions about contributing:

1. Check existing documentation
2. Search closed issues for similar questions
3. Open a new issue with the `question` label
4. Reach out to maintainers

Thank you for contributing! 🎉
