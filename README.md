# Have I Been Pwned - Python Library

[![PyPI version](https://badge.fury.io/py/haveibeenpwned-py.svg)](https://badge.fury.io/py/haveibeenpwned-py)
[![Python Support](https://img.shields.io/pypi/pyversions/haveibeenpwned-py.svg)](https://pypi.org/project/haveibeenpwned-py/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive, easy-to-use Python library for the [Have I Been Pwned](https://haveibeenpwned.com/) API v3. Check if email accounts have been compromised in data breaches, validate password security, and access paste and stealer log data - all through a clean, Pythonic interface.

## ✨ Features

- 🔐 **Pwned Passwords**: Check passwords using k-Anonymity (no API key needed)
- 📧 **Breach Data**: Search breached accounts and get detailed breach information
- 📋 **Pastes**: Find paste exposures for email addresses
- 🎯 **Stealer Logs**: Access malware-captured credentials (Pwned 5+ subscription)
- 🏢 **Domain Search**: Search breaches across verified domains
- 🛡️ **Type Safety**: Full type hints for better IDE support and code quality
- ⚡ **Error Handling**: Comprehensive exception hierarchy for robust error management
- 🚦 **Rate Limiting**: Automatic handling of API rate limits

## 📚 Documentation

- **[Installation Guide](INSTALL.md)** - How to install and configure the library
- **[Usage Guide](USAGE.md)** - Comprehensive usage examples and API reference
- **[Contributing Guide](CONTRIBUTING.md)** - How to contribute to the project
- **[Development Guide](DEVELOPMENT.md)** - Development setup and testing

## 🚀 Quick Start

### Installation

```bash
pip install haveibeenpwned-py
```

[Full installation instructions →](INSTALL.md)

### Simple Example

```python
from haveibeenpwned import HIBP

# Check if an account has been breached (requires API key)
hibp = HIBP(api_key="your-api-key-here")
breaches = hibp.get_account_breaches("test@example.com")
for breach in breaches:
    print(f"🚨 {breach.name}: {breach.pwn_count:,} accounts affected")

# Check if a password has been pwned (no API key required!)
hibp_passwords = HIBP()
count = hibp_passwords.is_password_pwned("password123")
if count > 0:
    print(f"⚠️  Password found in {count:,} breaches!")
else:
    print("✓ Password not found in any breaches")
```

[More examples and detailed usage →](USAGE.md)

## 📖 API Endpoints

This library provides complete coverage of all HIBP API v3 endpoints:

### Breaches API (7 endpoints)
- ✅ Check account breaches
- ✅ Get all breaches
- ✅ Get single breach details
- ✅ Get latest breach
- ✅ Get data classes
- ✅ Get domain breaches (requires verification)
- ✅ Get subscribed domains

### Pastes API
- ✅ Get pastes for an account

### Stealer Logs API (Pwned 5+ subscription)
- ✅ Get stealer logs by email
- ✅ Get stealer logs by website
- ✅ Get stealer logs by email domain

### Subscription API
- ✅ Get subscription status

### Pwned Passwords API (no API key required)
- ✅ Check password by plaintext
- ✅ Search by hash prefix (k-Anonymity)
- ✅ SHA-1 and NTLM hash support

## 🔑 API Key

Most endpoints require an API key from Have I Been Pwned. The **Pwned Passwords API does not require authentication**.

**Get your API key:** https://haveibeenpwned.com/API/Key

**Test API key for development:** `00000000000000000000000000000000`

[Learn more about API key setup →](INSTALL.md#api-key-setup)

## 🏗️ Project Structure

```
haveibeenpwned/
├── haveibeenpwned/          # Main package
│   ├── api.py               # Main HIBP interface
│   ├── breach.py            # Breach endpoints
│   ├── client.py            # HTTP client
│   ├── exceptions.py        # Custom exceptions
│   ├── models.py            # Data models
│   ├── passwords.py         # Pwned Passwords API
│   ├── pastes.py            # Pastes endpoints
│   ├── stealer_logs.py      # Stealer logs endpoints
│   └── subscription.py      # Subscription endpoints
├── tests/                   # Comprehensive test suite
├── docs/                    # Documentation
│   ├── INSTALL.md           # Installation guide
│   ├── USAGE.md             # Usage guide
│   ├── CONTRIBUTING.md      # Contributing guide
│   └── DEVELOPMENT.md       # Development guide
└── README.md                # This file
```

## 🤝 Contributing

Contributions are welcome! This project maintains high standards:

- ✅ **Test Coverage**: >95% required
- ✅ **Type Hints**: Full type annotations
- ✅ **Documentation**: Comprehensive docs and examples
- ✅ **Code Quality**: Follows PEP 8 and best practices

[Read the contributing guide →](CONTRIBUTING.md)

## 🧪 Testing

```bash
# Run all tests
./run_tests.sh all

# Run unit tests only (fast, no API key needed)
./run_tests.sh unit

# Run integration tests (requires HIBP_API_KEY)
export HIBP_API_KEY="your-api-key"
./run_tests.sh live

# Check coverage
./run_tests.sh coverage
```

[Learn more about testing →](DEVELOPMENT.md#testing)

## 📋 Requirements

- Python 3.8 or higher
- requests >= 2.25.0

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Attribution

This library uses the [Have I Been Pwned API](https://haveibeenpwned.com/API/v3). When using this library, you must provide clear attribution to Have I Been Pwned as required by their [Terms of Service](https://haveibeenpwned.com/API/v3#AcceptableUse).

The breach and paste data is licensed under [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).

## ⚠️ Disclaimer

This is an unofficial library and is not affiliated with Troy Hunt or Have I Been Pwned. Use responsibly and in accordance with the [HIBP Acceptable Use Policy](https://haveibeenpwned.com/API/v3#AcceptableUse).

## 🔗 Resources

- **Website**: [Have I Been Pwned](https://haveibeenpwned.com/)
- **API Documentation**: [HIBP API v3](https://haveibeenpwned.com/API/v3)
- **Get API Key**: [Purchase API Access](https://haveibeenpwned.com/API/Key)
- **PyPI Package**: [haveibeenpwned-py](https://pypi.org/project/haveibeenpwned-py/)
- **GitHub Repository**: [dynacylabs/haveibeenpwned](https://github.com/dynacylabs/haveibeenpwned)

---

**Made with ❤️ for security and privacy**

## Usage Examples

### Breaches

#### Check Account Breaches

```python
# Get all breaches for an account
breaches = hibp.get_account_breaches("test@example.com")

# Get full breach details (not truncated)
breaches = hibp.get_account_breaches(
    "test@example.com",
    truncate_response=False
)

# Filter by domain
breaches = hibp.get_account_breaches(
    "test@example.com",
    domain="adobe.com"
)

# Exclude unverified breaches
breaches = hibp.get_account_breaches(
    "test@example.com",
    include_unverified=False
)
```

#### Get All Breaches

```python
# Get all breaches in the system
all_breaches = hibp.get_all_breaches()

# Filter by domain
adobe_breaches = hibp.get_all_breaches(domain="adobe.com")

# Get only spam lists
spam_lists = hibp.get_all_breaches(is_spam_list=True)
```

#### Get Single Breach

```python
# Get details for a specific breach
breach = hibp.get_breach("Adobe")
print(f"Name: {breach.name}")
print(f"Date: {breach.breach_date}")
print(f"Accounts: {breach.pwn_count}")
print(f"Data classes: {', '.join(breach.data_classes)}")
```

#### Get Latest Breach

```python
# Get the most recently added breach
latest = hibp.get_latest_breach()
print(f"Latest breach: {latest.name} added on {latest.added_date}")
```

#### Get Data Classes

```python
# Get all data classes
data_classes = hibp.get_data_classes()
print("Available data classes:", data_classes)
```

### Domain Search

```python
# Get breached accounts for your verified domain
domain_breaches = hibp.get_domain_breaches("example.com")
for alias, breach_names in domain_breaches.items():
    print(f"{alias}@example.com: {', '.join(breach_names)}")

# Get your subscribed domains
domains = hibp.get_subscribed_domains()
for domain in domains:
    print(f"{domain.domain_name}: {domain.pwn_count} breached accounts")
```

### Pastes

```python
# Get pastes for an account
pastes = hibp.get_account_pastes("test@example.com")
for paste in pastes:
    print(f"Source: {paste.source}")
    print(f"ID: {paste.id}")
    print(f"Date: {paste.date}")
    print(f"Emails: {paste.email_count}")
```

### Stealer Logs

Requires Pwned 5+ subscription.

```python
# Get stealer log domains for an email
domains = hibp.get_stealer_logs_by_email("test@example.com")
print(f"Credentials captured on: {', '.join(domains)}")

# Get email addresses captured on a website
emails = hibp.get_stealer_logs_by_website("netflix.com")
print(f"Compromised accounts: {', '.join(emails)}")

# Get stealer logs by email domain
logs = hibp.get_stealer_logs_by_email_domain("example.com")
for alias, websites in logs.items():
    print(f"{alias}@example.com compromised on: {', '.join(websites)}")
```

### Pwned Passwords

No API key required for Pwned Passwords!

```python
# Simple password check
count = hibp.is_password_pwned("password123")
if count > 0:
    print(f"⚠️  Password found {count} times in breaches!")
else:
    print("✓ Password not found in breaches")

# Use NTLM hash instead of SHA-1
count = hibp.is_password_pwned("password123", use_ntlm=True)

# Add padding for enhanced privacy
count = hibp.is_password_pwned("password123", add_padding=True)

# Search by hash prefix directly
results = hibp.search_password_hashes("21BD1")  # First 5 chars of SHA-1 hash
for suffix, count in results.items():
    print(f"Hash suffix {suffix}: seen {count} times")
```

### Subscription Status

```python
# Get your subscription details
subscription = hibp.get_subscription_status()
print(f"Plan: {subscription.subscription_name}")
print(f"Rate limit: {subscription.rpm} requests per minute")
print(f"Max domain size: {subscription.domain_search_max_breached_accounts}")
print(f"Includes stealer logs: {subscription.includes_stealer_logs}")
print(f"Valid until: {subscription.subscribed_until}")
```

## Advanced Usage

### Using Individual API Modules

You can also access the API modules directly for more control:

```python
from haveibeenpwned import HIBP

hibp = HIBP(api_key="your-api-key")

# Access individual API modules
breaches = hibp.breaches.get_breaches_for_account("test@example.com")
pastes = hibp.pastes.get_pastes_for_account("test@example.com")
status = hibp.subscription.get_status()
count = hibp.passwords.check_password("password123")
```

### Custom User Agent

```python
hibp = HIBP(
    api_key="your-api-key",
    user_agent="MyApp/1.0 (contact@example.com)"
)
```

### Custom Timeout

```python
hibp = HIBP(
    api_key="your-api-key",
    timeout=60  # 60 seconds
)
```

## Error Handling

The library provides detailed exceptions for different error scenarios:

```python
from haveibeenpwned import (
    HIBP,
    NotFoundError,
    RateLimitError,
    AuthenticationError,
    BadRequestError,
    ForbiddenError,
    ServiceUnavailableError,
    HIBPError,
)

hibp = HIBP(api_key="your-api-key")

try:
    breaches = hibp.get_account_breaches("test@example.com")
except NotFoundError:
    print("Account not found in any breaches")
except RateLimitError as e:
    print(f"Rate limit exceeded. Retry after {e.retry_after} seconds")
except AuthenticationError:
    print("Invalid API key")
except BadRequestError as e:
    print(f"Bad request: {e}")
except ForbiddenError:
    print("Access forbidden - check user agent")
except ServiceUnavailableError:
    print("Service temporarily unavailable")
except HIBPError as e:
    print(f"API error: {e}")
```

## Models

The library provides typed models for API responses:

### Breach

```python
breach = hibp.get_breach("Adobe")

# Access breach properties
breach.name                  # "Adobe"
breach.title                 # "Adobe"
breach.domain                # "adobe.com"
breach.breach_date           # "2013-10-04"
breach.added_date            # "2013-12-04T00:00:00Z"
breach.modified_date         # "2022-05-15T23:52:49Z"
breach.pwn_count             # 152445165
breach.description           # HTML description
breach.data_classes          # ["Email addresses", "Passwords", ...]
breach.is_verified           # True
breach.is_sensitive          # False
breach.is_retired            # False
breach.is_spam_list          # False
breach.logo_path             # "Adobe.png"

# Convert to dictionary
breach_dict = breach.to_dict()
```

### Paste

```python
paste = pastes[0]

paste.source                 # "Pastebin"
paste.id                     # "8Q0BvKD8"
paste.title                  # "syslog"
paste.date                   # "2014-03-04T19:14:54Z"
paste.email_count            # 139
```

### Subscription

```python
subscription = hibp.get_subscription_status()

subscription.subscription_name                # "Pwned 1"
subscription.description                      # "Up to 10 passwords per minute..."
subscription.subscribed_until                 # "2024-12-31T23:59:59Z"
subscription.rpm                              # 10
subscription.domain_search_max_breached_accounts  # 100
subscription.includes_stealer_logs            # False
```

## Rate Limiting

The API enforces rate limits based on your subscription level. When rate limited:

```python
from haveibeenpwned import RateLimitError

try:
    breaches = hibp.get_account_breaches("test@example.com")
except RateLimitError as e:
    # Wait for the specified time
    import time
    time.sleep(e.retry_after)
    # Retry the request
    breaches = hibp.get_account_breaches("test@example.com")
```

## API Key

Most endpoints require an API key. You can obtain one from:
https://haveibeenpwned.com/API/Key

The Pwned Passwords API does not require an API key.

### Test API Key

For testing, you can use the test API key `00000000000000000000000000000000` with test accounts:

```python
hibp = HIBP(api_key="00000000000000000000000000000000")

# These test accounts work with the test key
breaches = hibp.get_account_breaches("account-exists@hibp-integration-tests.com")
breaches = hibp.get_account_breaches("spam-list-only@hibp-integration-tests.com")
breaches = hibp.get_account_breaches("stealer-log@hibp-integration-tests.com")
```

## Requirements

- Python 3.8+
- requests >= 2.25.0

## License

This project is licensed under the MIT License.

## Attribution

This library uses the [Have I Been Pwned API](https://haveibeenpwned.com/API/v3). The breach and paste data is licensed under [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/). When using this library, you must provide clear attribution to Have I Been Pwned.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Testing

The library includes a comprehensive test suite with both unit tests (mocked) and integration tests (live API).

### Running Tests

```bash
# Install test dependencies
pip install -r requirements-test.txt

# Run all tests
pytest

# Run only unit tests (no API key needed)
pytest -m unit

# Run only integration tests (requires HIBP_API_KEY)
export HIBP_API_KEY="your-api-key"
pytest -m integration

# Run with coverage
pytest --cov=haveibeenpwned --cov-report=html
```

### Test Coverage

The test suite includes:
- ✅ **Client & HTTP**: Request handling, error responses, timeouts
- ✅ **Models**: Breach, Paste, Subscription, SubscribedDomain
- ✅ **Breaches API**: All 7 endpoints with full parameter testing
- ✅ **Pwned Passwords**: SHA-1, NTLM, padding, k-Anonymity
- ✅ **Pastes API**: Account paste retrieval
- ✅ **Stealer Logs API**: Email, website, and domain searches
- ✅ **Subscription API**: Status retrieval
- ✅ **Main Interface**: All convenience methods

Target coverage: **90%+**

## Publishing & Releases

This package uses GitHub Actions for automated publishing to PyPI via Trusted Publishing.

### For Maintainers: Making a Release

Once PyPI Trusted Publishing is configured, releases are simple:

```bash
# Using the release script (recommended)
./release.sh 1.0.1

# Or manually:
# 1. Update version in setup.py
# 2. Commit: git commit -am "Bump version to 1.0.1"
# 3. Tag: git tag -a v1.0.1 -m "Release 1.0.1"
# 4. Push: git push origin main --tags
# 5. Create GitHub release (triggers auto-publish to PyPI)
```

The GitHub Actions workflow will automatically:
- ✅ Build the package
- ✅ Run tests
- ✅ Publish to PyPI (with required approval via the `pypi` environment)

### First-Time PyPI Setup

For the initial release, PyPI Trusted Publishing must be configured:

1. **Create PyPI account** (if needed):
   - Go to https://pypi.org/account/register/
   - Enable 2FA: https://pypi.org/manage/account/

2. **Set up Trusted Publishing**:
   - Go to https://pypi.org/manage/account/publishing/
   - Add a new publisher:
     - PyPI Project Name: `haveibeenpwned-py`
     - Owner: `dynacylabs`
     - Repository: `haveibeenpwned`
     - Workflow: `publish.yml`
     - Environment name: `pypi`
   - Click "Add"

3. **Configure GitHub Environment Protection**:
   - Go to your GitHub repo → Settings → Environments
   - Create environment: `pypi`
   - Add required reviewers (for approval before publishing)
   - Save protection rules

4. **Make your first release**:
   ```bash
   ./release.sh 1.0.0
   ```

### Version Numbering

Follow [Semantic Versioning](https://semver.org/):
- **MAJOR** (1.0.0 → 2.0.0): Breaking changes
- **MINOR** (1.0.0 → 1.1.0): New features, backward compatible
- **PATCH** (1.0.0 → 1.0.1): Bug fixes, backward compatible

### Release Checklist

Before releasing:
- [ ] All tests pass: `./run_tests.sh all`
- [ ] Coverage is >90%: `./run_tests.sh coverage`
- [ ] README.md is up-to-date
- [ ] Version number updated in `setup.py`
- [ ] CHANGELOG or release notes prepared
- [ ] No uncommitted changes

Target coverage: **90%+**

## API Reference

### Complete Endpoint Coverage

#### Breaches (7 endpoints)
- `get_account_breaches(account)` - Get all breaches for an account
- `get_all_breaches()` - Get all breaches in the system
- `get_breach(name)` - Get a single breach by name
- `get_latest_breach()` - Get the most recently added breach
- `get_data_classes()` - Get all data classes
- `get_domain_breaches(domain)` - Get breached emails for a domain
- `get_subscribed_domains()` - Get all subscribed domains

#### Pastes (1 endpoint)
- `get_account_pastes(account)` - Get all pastes for an account

#### Stealer Logs (3 endpoints)
- `get_stealer_logs_by_email(email)` - Get domains by email
- `get_stealer_logs_by_website(domain)` - Get emails by website domain
- `get_stealer_logs_by_email_domain(domain)` - Get aliases by email domain

#### Subscription (1 endpoint)
- `get_subscription_status()` - Get subscription details

#### Pwned Passwords (no API key required)
- `is_password_pwned(password)` - Check if password is compromised
- `search_password_hashes(prefix)` - Search by hash prefix

### API Key

Most endpoints require an API key. You can obtain one from:
https://haveibeenpwned.com/API/Key

The Pwned Passwords API does not require an API key.

#### Test API Key

For testing, you can use the test API key `00000000000000000000000000000000` with test accounts:

```python
hibp = HIBP(api_key="00000000000000000000000000000000")

# These test accounts work with the test key
breaches = hibp.get_account_breaches("account-exists@hibp-integration-tests.com")
breaches = hibp.get_account_breaches("spam-list-only@hibp-integration-tests.com")
breaches = hibp.get_account_breaches("stealer-log@hibp-integration-tests.com")
```

## Rate Limiting

The API enforces rate limits based on your subscription level. When rate limited:

```python
from haveibeenpwned import RateLimitError

try:
    breaches = hibp.get_account_breaches("test@example.com")
except RateLimitError as e:
    # Wait for the specified time
    import time
    time.sleep(e.retry_after)
    # Retry the request
    breaches = hibp.get_account_breaches("test@example.com")
```

## Contributing

Contributions are welcome! Please ensure your contributions meet the following requirements:

### Code Quality Standards

- **All tests must pass**: Run `./run_tests.sh all` to verify all tests pass
- **Code coverage must be >95%**: Run `./run_tests.sh coverage` to check coverage
- **Follow existing code style**: Match the formatting and patterns used in the codebase
- **Add tests for new features**: Both unit tests (mocked) and integration tests (live API calls where appropriate)
- **Update documentation**: Keep README.md and docstrings up to date

### Testing Your Changes

Before submitting a pull request:

```bash
# Run all tests
./run_tests.sh all

# Check coverage (must be >95%)
./run_tests.sh coverage

# Run unit tests only (fast, no API key needed)
./run_tests.sh unit

# Run live integration tests (requires HIBP_API_KEY)
export HIBP_API_KEY="your-api-key-here"
./run_tests.sh live
```

### Submitting Changes

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-new-feature`)
3. Make your changes with appropriate tests
4. Ensure all tests pass and coverage is >95%
5. Commit your changes (`git commit -am 'Add new feature'`)
6. Push to the branch (`git push origin feature/my-new-feature`)
7. Create a Pull Request

## Disclaimer

This is an unofficial library and is not affiliated with Troy Hunt or Have I Been Pwned. Use responsibly and in accordance with the [HIBP Acceptable Use Policy](https://haveibeenpwned.com/API/v3#AcceptableUse).

## Resources

- [Have I Been Pwned Website](https://haveibeenpwned.com/)
- [HIBP API Documentation](https://haveibeenpwned.com/API/v3)
- [Get an API Key](https://haveibeenpwned.com/API/Key)
- [PyPI Package](https://pypi.org/project/haveibeenpwned-py/)
- [GitHub Repository](https://github.com/dynacylabs/haveibeenpwned)

## Project Structure

```
hibp/
├── hibp/                    # Main package
│   ├── __init__.py          # Package exports
│   ├── api.py               # Main HIBP interface
│   ├── breach.py            # Breach endpoints
│   ├── client.py            # HTTP client
│   ├── exceptions.py        # Custom exceptions
│   ├── models.py            # Data models
│   ├── passwords.py         # Pwned Passwords API
│   ├── pastes.py            # Pastes endpoints
│   ├── stealer_logs.py      # Stealer logs endpoints
│   └── subscription.py      # Subscription endpoints
├── tests/                   # Test suite
│   ├── conftest.py
│   ├── test_api.py
│   ├── test_breach.py
│   ├── test_client.py
│   ├── test_models.py
│   ├── test_other_endpoints.py
│   └── test_passwords.py
├── .github/
│   ├── workflows/
│   │   ├── tests.yml              # Automated testing
│   │   ├── publish.yml            # PyPI publishing
│   │   ├── security.yml           # Security scanning
│   │   └── dependency-updates.yml # Dependency monitoring
│   └── dependabot.yml             # Automated dependency updates
├── setup.py                 # Package setup
├── requirements.txt         # Dependencies
├── release.sh               # Automated release script
├── run_tests.sh             # Test runner
└── README.md                # This file
```

---

**Made with ❤️ for security and privacy**