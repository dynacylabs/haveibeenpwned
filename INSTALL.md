# Installation Guide

This guide covers how to install the Have I Been Pwned Python library.

## Table of Contents

- [Requirements](#requirements)
- [Installation Methods](#installation-methods)
  - [From PyPI (Recommended)](#from-pypi-recommended)
  - [From Source](#from-source)
  - [Development Installation](#development-installation)
- [API Key Setup](#api-key-setup)
- [Verification](#verification)

## Requirements

- **Python**: 3.8 or higher
- **Dependencies**: 
  - `requests >= 2.25.0`

## Installation Methods

### From PyPI (Recommended)

The easiest way to install the library is from PyPI using pip:

```bash
pip install haveibeenpwned-py
```

To upgrade to the latest version:

```bash
pip install --upgrade haveibeenpwned-py
```

### From Source

To install directly from the GitHub repository:

```bash
git clone https://github.com/dynacylabs/haveibeenpwned.git
cd haveibeenpwned
pip install .
```

### Development Installation

For development, install in editable mode with all dependencies:

```bash
git clone https://github.com/dynacylabs/haveibeenpwned.git
cd haveibeenpwned
pip install -e .
```

This allows you to make changes to the code and see them reflected immediately without reinstalling.

## API Key Setup

Most HIBP API endpoints require an API key. The Pwned Passwords API is the exception and does not require authentication.

### Obtaining an API Key

1. Visit: https://haveibeenpwned.com/API/Key
2. Purchase a subscription plan (various tiers available)
3. You'll receive an API key via email

### Using Your API Key

Once you have an API key, you can use it in your code:

```python
from haveibeenpwned import HIBP

hibp = HIBP(api_key="your-api-key-here")
```

### Environment Variable (Recommended)

For better security, store your API key as an environment variable:

```bash
export HIBP_API_KEY="your-api-key-here"
```

Then in your code:

```python
import os
from haveibeenpwned import HIBP

hibp = HIBP(api_key=os.getenv("HIBP_API_KEY"))
```

### Test API Key

For testing and development, HIBP provides a test API key that works with specific test accounts:

**Test API Key**: `00000000000000000000000000000000`

**Test Accounts**:
- `account-exists@hibp-integration-tests.com`
- `spam-list-only@hibp-integration-tests.com`
- `stealer-log@hibp-integration-tests.com`

Example:

```python
from haveibeenpwned import HIBP

# Using test key
hibp = HIBP(api_key="00000000000000000000000000000000")

# Query test account
breaches = hibp.get_account_breaches("account-exists@hibp-integration-tests.com")
print(f"Found {len(breaches)} breaches")
```

## Verification

After installation, verify everything is working:

```python
from haveibeenpwned import HIBP

# Test without API key (Pwned Passwords)
hibp_free = HIBP()
count = hibp_free.is_password_pwned("password")
print(f"Password 'password' found {count} times in breaches")

# Test with API key (if you have one)
hibp = HIBP(api_key="your-api-key-here")
breaches = hibp.get_all_breaches()
print(f"Total breaches in database: {len(breaches)}")
```

If both commands execute without errors, the installation is successful.

## Troubleshooting

### Import Errors

If you encounter import errors:

```bash
# Ensure the package is installed
pip list | grep haveibeenpwned

# Try reinstalling
pip uninstall haveibeenpwned-py
pip install haveibeenpwned-py
```

### Dependency Issues

If you have issues with dependencies:

```bash
# Install dependencies explicitly
pip install requests>=2.25.0

# Or use the requirements file
pip install -r requirements.txt
```

### Version Conflicts

If you have version conflicts with other packages:

```bash
# Create a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install in the isolated environment
pip install haveibeenpwned-py
```

## Next Steps

- Read the [Usage Guide](USAGE.md) for examples and API documentation
- Review [Contributing Guidelines](CONTRIBUTING.md) if you want to contribute
- Check [Development Guide](DEVELOPMENT.md) for development setup
