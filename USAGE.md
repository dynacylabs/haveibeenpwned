# Usage Guide

This guide provides comprehensive examples for using the Have I Been Pwned Python library.

## Table of Contents

- [Quick Start](#quick-start)
- [Breaches API](#breaches-api)
- [Domain Search API](#domain-search-api)
- [Pastes API](#pastes-api)
- [Stealer Logs API](#stealer-logs-api)
- [Pwned Passwords API](#pwned-passwords-api)
- [Subscription API](#subscription-api)
- [Advanced Usage](#advanced-usage)
- [Error Handling](#error-handling)
- [Data Models](#data-models)
- [Rate Limiting](#rate-limiting)

## Quick Start

### Simple Interface

The easiest way to use the library is through the `HIBP` class:

```python
from haveibeenpwned import HIBP

# Initialize with your API key
hibp = HIBP(api_key="your-api-key-here")

# Check if an account has been breached
breaches = hibp.get_account_breaches("test@example.com")
for breach in breaches:
    print(f"{breach.name}: {breach.pwn_count} accounts affected")

# Check if a password has been pwned (no API key needed)
hibp_free = HIBP()  # No API key needed for passwords
count = hibp_free.is_password_pwned("password123")
if count > 0:
    print(f"Password found in {count} breaches!")
else:
    print("Password not found in breaches")
```

## Breaches API

The Breaches API provides access to all breach data in the HIBP database.

### Check Account Breaches

Search for breaches associated with an email account:

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

### Get All Breaches

Retrieve all breaches in the HIBP system:

```python
# Get all breaches in the system
all_breaches = hibp.get_all_breaches()

# Filter by domain
adobe_breaches = hibp.get_all_breaches(domain="adobe.com")

# Get only spam lists
spam_lists = hibp.get_all_breaches(is_spam_list=True)
```

### Get Single Breach

Get detailed information about a specific breach:

```python
breach = hibp.get_breach("Adobe")
print(f"Name: {breach.name}")
print(f"Date: {breach.breach_date}")
print(f"Accounts: {breach.pwn_count}")
print(f"Data classes: {', '.join(breach.data_classes)}")
```

### Get Latest Breach

Get the most recently added breach:

```python
latest = hibp.get_latest_breach()
print(f"Latest breach: {latest.name} added on {latest.added_date}")
```

### Get Data Classes

Get all data classifications:

```python
data_classes = hibp.get_data_classes()
print("Available data classes:", data_classes)
```

## Domain Search API

The Domain Search API allows you to search for breached accounts across verified domains.

### Get Domain Breaches

**Requires**: Domain verification and appropriate subscription

```python
# Get breached accounts for your verified domain
domain_breaches = hibp.get_domain_breaches("example.com")
for alias, breach_names in domain_breaches.items():
    print(f"{alias}@example.com: {', '.join(breach_names)}")
```

### Get Subscribed Domains

```python
# Get your subscribed domains
domains = hibp.get_subscribed_domains()
for domain in domains:
    print(f"{domain.domain_name}: {domain.pwn_count} breached accounts")
```

## Pastes API

The Pastes API returns all pastes for an account that has been compromised in a paste.

### Get Account Pastes

```python
pastes = hibp.get_account_pastes("test@example.com")
for paste in pastes:
    print(f"Source: {paste.source}")
    print(f"ID: {paste.id}")
    print(f"Date: {paste.date}")
    print(f"Emails: {paste.email_count}")
    print("---")
```

## Stealer Logs API

The Stealer Logs API provides access to credentials captured by malware.

**Requires**: Pwned 5+ subscription

### Get Stealer Logs by Email

```python
# Get domains where credentials were captured
domains = hibp.get_stealer_logs_by_email("test@example.com")
print(f"Credentials captured on: {', '.join(domains)}")
```

### Get Stealer Logs by Website

```python
# Get email addresses captured on a specific website
emails = hibp.get_stealer_logs_by_website("netflix.com")
print(f"Compromised accounts: {', '.join(emails)}")
```

### Get Stealer Logs by Email Domain

```python
# Get stealer logs for an entire email domain
logs = hibp.get_stealer_logs_by_email_domain("example.com")
for alias, websites in logs.items():
    print(f"{alias}@example.com compromised on: {', '.join(websites)}")
```

## Pwned Passwords API

The Pwned Passwords API allows you to check if a password has been compromised in data breaches.

**No API key required!**

### Basic Password Check

```python
# Simple password check
count = hibp.is_password_pwned("password123")
if count > 0:
    print(f"⚠️  Password found {count} times in breaches!")
else:
    print("✓ Password not found in breaches")
```

### Advanced Password Check

```python
# Use NTLM hash instead of SHA-1
count = hibp.is_password_pwned("password123", use_ntlm=True)

# Add padding for enhanced privacy
count = hibp.is_password_pwned("password123", add_padding=True)
```

### Search by Hash Prefix

```python
# Search by hash prefix directly
results = hibp.search_password_hashes("21BD1")  # First 5 chars of SHA-1 hash
for suffix, count in results.items():
    print(f"Hash suffix {suffix}: seen {count} times")
```

### How k-Anonymity Works

The Pwned Passwords API uses k-Anonymity to protect your password. Instead of sending your password (or full hash), you:

1. Hash your password using SHA-1 or NTLM
2. Send only the first 5 characters of the hash
3. Receive all hashes that start with those 5 characters
4. Search locally for your full hash

This means the API never sees your actual password or even your full hash.

## Subscription API

Check your subscription status and limits.

### Get Subscription Status

```python
subscription = hibp.get_subscription_status()
print(f"Plan: {subscription.subscription_name}")
print(f"Rate limit: {subscription.rpm} requests per minute")
print(f"Max domain size: {subscription.domain_search_max_breached_accounts}")
print(f"Includes stealer logs: {subscription.includes_stealer_logs}")
print(f"Valid until: {subscription.subscribed_until}")
```

## Advanced Usage

### Using Individual API Modules

For more control, access API modules directly:

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

Set a custom user agent to identify your application:

```python
hibp = HIBP(
    api_key="your-api-key",
    user_agent="MyApp/1.0 (contact@example.com)"
)
```

**Note**: The HIBP API requires a meaningful user agent. Generic user agents may result in 403 Forbidden errors.

### Custom Timeout

Adjust the request timeout:

```python
hibp = HIBP(
    api_key="your-api-key",
    timeout=60  # 60 seconds
)
```

## Error Handling

The library provides detailed exceptions for different error scenarios.

### Exception Types

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
```

### Handling Specific Errors

```python
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

### Error Details

| Exception | Status Code | Description |
|-----------|-------------|-------------|
| `NotFoundError` | 404 | No breaches/pastes found for the account |
| `RateLimitError` | 429 | Rate limit exceeded, includes `retry_after` |
| `AuthenticationError` | 401 | Invalid or missing API key |
| `BadRequestError` | 400 | Invalid request parameters |
| `ForbiddenError` | 403 | Forbidden, usually due to invalid user agent |
| `ServiceUnavailableError` | 503 | Service temporarily unavailable |
| `HIBPError` | Any | Base exception for all HIBP errors |

## Data Models

The library provides typed models for all API responses.

### Breach Model

```python
breach = hibp.get_breach("Adobe")

# Available properties
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

### Paste Model

```python
paste = pastes[0]

# Available properties
paste.source                 # "Pastebin"
paste.id                     # "8Q0BvKD8"
paste.title                  # "syslog"
paste.date                   # "2014-03-04T19:14:54Z"
paste.email_count            # 139
```

### Subscription Model

```python
subscription = hibp.get_subscription_status()

# Available properties
subscription.subscription_name                # "Pwned 1"
subscription.description                      # "Up to 10 passwords per minute..."
subscription.subscribed_until                 # "2024-12-31T23:59:59Z"
subscription.rpm                              # 10
subscription.domain_search_max_breached_accounts  # 100
subscription.includes_stealer_logs            # False
```

### SubscribedDomain Model

```python
domains = hibp.get_subscribed_domains()
for domain in domains:
    # Available properties
    domain.domain_name           # "example.com"
    domain.pwn_count             # 42
    domain.next_subscription_renewal  # "2024-12-31T23:59:59Z"
```

## Rate Limiting

The HIBP API enforces rate limits based on your subscription level.

### Subscription Tiers and Limits

| Tier | Requests Per Minute |
|------|---------------------|
| Pwned 1 | 10 |
| Pwned 2 | 20 |
| Pwned 5 | 50 |
| Pwned 10 | 100 |

### Handling Rate Limits

```python
from haveibeenpwned import RateLimitError
import time

try:
    breaches = hibp.get_account_breaches("test@example.com")
except RateLimitError as e:
    # Wait for the specified time
    print(f"Rate limited. Waiting {e.retry_after} seconds...")
    time.sleep(e.retry_after)
    # Retry the request
    breaches = hibp.get_account_breaches("test@example.com")
```

### Best Practices

1. **Respect Rate Limits**: Always check your subscription tier's rate limit
2. **Handle Retry-After**: Use the `retry_after` value from `RateLimitError`
3. **Implement Backoff**: Consider exponential backoff for repeated failures
4. **Batch Requests**: Group operations when possible to minimize API calls

### Automatic Rate Limit Handling

```python
from haveibeenpwned import RateLimitError
import time

def get_breaches_with_retry(email, max_retries=3):
    """Get breaches with automatic retry on rate limit."""
    for attempt in range(max_retries):
        try:
            return hibp.get_account_breaches(email)
        except RateLimitError as e:
            if attempt < max_retries - 1:
                time.sleep(e.retry_after)
            else:
                raise
    return None

# Use it
breaches = get_breaches_with_retry("test@example.com")
```

## API Endpoint Reference

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

## Additional Resources

- [Installation Guide](INSTALL.md) - Installation and setup
- [Contributing Guide](CONTRIBUTING.md) - How to contribute
- [Development Guide](DEVELOPMENT.md) - Development setup
- [HIBP API Documentation](https://haveibeenpwned.com/API/v3) - Official API docs
- [Get an API Key](https://haveibeenpwned.com/API/Key) - Purchase API access
