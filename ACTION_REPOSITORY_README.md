# GitHub Actions Toolkit

A comprehensive collection of reusable GitHub Actions for Python projects with integrated Grafana Loki logging.

## 🚀 Quick Start

```yaml
name: CI Pipeline

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run tests
        uses: YOUR_USERNAME/github-actions-toolkit/pytest@v1
        with:
          python_version: '3.12'
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}
```

## 📦 Available Actions

### Testing & Quality

| Action | Description | Path |
|--------|-------------|------|
| **pytest** | Run pytest with coverage | `pytest@v1` |
| **integration-tests** | Run integration tests | `integration-tests@v1` |
| **benchmark-tests** | Performance benchmarks | `benchmark-tests@v1` |
| **load-test** | Load testing with Locust | `load-test@v1` |
| **mutation-test** | Mutation testing | `mutation-test@v1` |

### Code Quality

| Action | Description | Path |
|--------|-------------|------|
| **ruff-format** | Format checking | `ruff-format@v1` |
| **ruff-check** | Linting | `ruff-check@v1` |
| **mypy** | Type checking | `mypy@v1` |
| **radon** | Complexity analysis | `radon@v1` |
| **vulture** | Dead code detection | `vulture@v1` |
| **coverage-threshold** | Enforce coverage | `coverage-threshold@v1` |
| **cloc** | Lines of code counting | `cloc@v1` |

### Security

| Action | Description | Path |
|--------|-------------|------|
| **bandit** | Security linting | `bandit@v1` |
| **pip-audit** | Dependency vulnerabilities | `pip-audit@v1` |
| **trivy-scan** | Container scanning | `trivy-scan@v1` |
| **secret-scan** | Secret detection | `secret-scan@v1` |

### Dependencies & Licensing

| Action | Description | Path |
|--------|-------------|------|
| **license-check** | License compliance | `license-check@v1` |
| **dependency-check** | Outdated packages | `dependency-check@v1` |
| **sbom-generate** | Generate SBOM | `sbom-generate@v1` |

### Build & Release

| Action | Description | Path |
|--------|-------------|------|
| **semantic-release** | Create releases | `semantic-release@v1` |
| **semantic-release-dry-run** | Preview releases | `semantic-release-dry-run@v1` |
| **container-build** | Build containers | `container-build@v1` |
| **docs-build** | Build documentation | `docs-build@v1` |

### Deployment

| Action | Description | Path |
|--------|-------------|------|
| **deploy-staging** | Deploy to staging | `deploy-staging@v1` |
| **deploy-production** | Deploy to production | `deploy-production@v1` |
| **db-migrate** | Database migrations | `db-migrate@v1` |
| **infra-validate** | Infrastructure validation | `infra-validate@v1` |

### Validation & Compliance

| Action | Description | Path |
|--------|-------------|------|
| **pre-commit-validate** | Pre-commit hooks | `pre-commit-validate@v1` |
| **changelog-validate** | Changelog validation | `changelog-validate@v1` |
| **commitlint** | Commit message linting | `commitlint@v1` |

### Notifications & Reporting

| Action | Description | Path |
|--------|-------------|------|
| **notify** | Slack/Discord/Teams | `notify@v1` |
| **publish-test-report** | Publish reports | `publish-test-report@v1` |
| **metrics-update** | Update dashboards | `metrics-update@v1` |
| **push-to-loki** | Send logs to Loki | `push-to-loki@v1` |

## 🔧 Setup

### 1. Configure Secrets

Add these secrets to your repository:

```
LOKI_URL       # Your Loki endpoint (e.g., https://loki.example.com)
LOKI_USER      # Loki username (optional)
LOKI_PASSWORD  # Loki password (optional)
```

### 2. Example Complete Workflow

```yaml
name: Complete CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:

jobs:
  # Code Quality
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Format check
        uses: YOUR_USERNAME/github-actions-toolkit/ruff-format@v1
        with:
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}

      - name: Lint
        uses: YOUR_USERNAME/github-actions-toolkit/ruff-check@v1
        with:
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}

      - name: Type check
        uses: YOUR_USERNAME/github-actions-toolkit/mypy@v1
        with:
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}

  # Security
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Security scan
        uses: YOUR_USERNAME/github-actions-toolkit/bandit@v1
        with:
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}

      - name: Dependency vulnerabilities
        uses: YOUR_USERNAME/github-actions-toolkit/pip-audit@v1
        with:
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}

      - name: Secret scan
        uses: YOUR_USERNAME/github-actions-toolkit/secret-scan@v1
        with:
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}

  # Testing
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run tests
        uses: YOUR_USERNAME/github-actions-toolkit/pytest@v1
        with:
          pytest_args: '--cov --cov-report=json'
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}

      - name: Check coverage
        uses: YOUR_USERNAME/github-actions-toolkit/coverage-threshold@v1
        with:
          minimum_coverage: 80
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}

  # Metrics
  metrics:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Count lines of code
        uses: YOUR_USERNAME/github-actions-toolkit/cloc@v1
        with:
          path: 'src'
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}

  # Release (on main only)
  release:
    if: github.ref == 'refs/heads/main'
    needs: [quality, security, test]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Semantic release
        uses: YOUR_USERNAME/github-actions-toolkit/semantic-release@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}
```

## 📊 Grafana Dashboard

All actions automatically push metrics to Loki with standardized labels:

- `job="github-actions"`
- `workflow="<workflow-name>"`
- `job_name="<job-name>"`
- `repository="<repo>"`
- `branch="<branch>"`
- `status="<success/failed>"`
- Plus action-specific labels

### Example LogQL Queries

```logql
# All workflow runs
{job="github-actions"}

# Failed jobs only
{job="github-actions", status="failed"}

# Test results
{job="github-actions", test_type=~".+"}

# Security scans
{job="github-actions", security_tool=~".+"}

# Lines of code over time
{job="github-actions", metric_type="lines_of_code"}
```

## 🎯 Features

- ✅ **Integrated Loki Logging** - All actions push results to Grafana Loki
- ✅ **Rich Outputs** - Structured outputs for downstream job usage
- ✅ **Artifact Uploads** - Automatic artifact storage for reports
- ✅ **GitHub Summaries** - Detailed step summaries in PR/run views
- ✅ **Fail-Safe** - `if: always()` ensures logging even on failure
- ✅ **Flexible Configuration** - Extensive input parameters
- ✅ **Cross-Platform** - Works on ubuntu, macos, windows runners

## 📝 Versioning

We use semantic versioning (SemVer):

- `@v1` - Latest v1.x.x (recommended, auto-updates)
- `@v1.0.0` - Specific version (pinned)
- `@main` - Latest commit (not recommended for production)

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details

## 🔗 Links

- [Documentation](./docs/)
- [Examples](./examples/)
- [Changelog](./CHANGELOG.md)
- [Issues](https://github.com/YOUR_USERNAME/github-actions-toolkit/issues)

## 💡 Tips

### Reusable Loki Configuration

Create a composite action for Loki config:

```yaml
# .github/actions/with-loki/action.yml
name: 'With Loki Config'
description: 'Wrapper that adds Loki configuration'
inputs:
  action:
    required: true
runs:
  using: composite
  steps:
    - uses: ${{ inputs.action }}
      with:
        loki_url: ${{ secrets.LOKI_URL }}
        loki_user: ${{ secrets.LOKI_USER }}
        loki_password: ${{ secrets.LOKI_PASSWORD }}
```

### Matrix Testing

```yaml
strategy:
  matrix:
    python-version: ['3.10', '3.11', '3.12']
steps:
  - uses: YOUR_USERNAME/github-actions-toolkit/pytest@v1
    with:
      python_version: ${{ matrix.python-version }}
      loki_url: ${{ secrets.LOKI_URL }}
```

### Parallel Job Execution

All actions can run in parallel for faster pipelines:

```yaml
jobs:
  lint: # runs in parallel
  test: # runs in parallel
  security: # runs in parallel
  deploy:
    needs: [lint, test, security] # waits for all
```
