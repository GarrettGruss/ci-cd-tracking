# Publishing Guide for GitHub Actions

This guide explains how to publish your reusable GitHub Actions for use in other projects.

## Quick Start (Automated)

Use the provided script:

```bash
./publish-actions.sh github-actions-toolkit YOUR_GITHUB_USERNAME v1.0.0
```

This will prepare everything and give you next steps.

## Manual Publishing Steps

### Option 1: Single Repository (Recommended)

**Best for**: Sharing multiple related actions as a toolkit

1. **Create a new GitHub repository**
   ```bash
   # On GitHub.com, create a new repository named "github-actions-toolkit"
   ```

2. **Clone and setup**
   ```bash
   git clone https://github.com/YOUR_USERNAME/github-actions-toolkit.git
   cd github-actions-toolkit
   ```

3. **Copy actions**
   ```bash
   # From your ci-cd-tracking project
   cp -r /path/to/ci-cd-tracking/.github/actions/* .
   cp /path/to/ci-cd-tracking/ACTION_REPOSITORY_README.md README.md
   ```

4. **Add LICENSE**
   ```bash
   # Create LICENSE file (MIT recommended)
   ```

5. **Commit and push**
   ```bash
   git add .
   git commit -m "Initial release of GitHub Actions toolkit"
   git push origin main
   ```

6. **Create version tag**
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0 - Initial release"
   git push origin v1.0.0

   # Also create major version tag for auto-updates
   git tag -a v1 -m "Release v1 (tracks latest v1.x.x)"
   git push origin v1
   ```

### Option 2: Separate Repositories

**Best for**: Publishing individual actions to GitHub Marketplace

For each action:

1. Create separate repository (e.g., `action-pytest`)
2. Copy single action directory
3. Add README specific to that action
4. Tag and release
5. Publish to Marketplace

### Option 3: Organization Repository

**Best for**: Internal/private sharing within organization

1. Create repository in your organization
2. Same as Option 1, but in org namespace
3. Configure repository permissions

## Directory Structure

Your published repository should look like:

```
github-actions-toolkit/
├── README.md                    # Main documentation
├── LICENSE                      # MIT License
├── CHANGELOG.md                # Version history
├── docs/
│   └── push-to-loki-action.md # Additional docs
├── pytest/
│   └── action.yml
├── ruff-check/
│   └── action.yml
├── mypy/
│   └── action.yml
└── ... (all other actions)
```

## Versioning Strategy

Use semantic versioning (SemVer):

### Tag Structure

- `v1.0.0` - Specific release (recommended for production)
- `v1.0` - Tracks latest patch (v1.0.x)
- `v1` - Tracks latest minor (v1.x.x) - **Most flexible**
- `main` - Latest code (not recommended)

### Creating Versions

```bash
# Patch release (bug fixes)
git tag -a v1.0.1 -m "Bug fixes"
git push origin v1.0.1

# Minor release (new features, backwards compatible)
git tag -a v1.1.0 -m "New features"
git tag -fa v1 -m "Update v1 to v1.1.0"
git push origin v1.1.0
git push origin v1 --force

# Major release (breaking changes)
git tag -a v2.0.0 -m "Breaking changes"
git tag -a v2 -m "Release v2"
git push origin v2.0.0
git push origin v2
```

## Usage Examples

### In Other Repositories

```yaml
# Using major version (auto-updates)
- uses: YOUR_USERNAME/github-actions-toolkit/pytest@v1
  with:
    loki_url: ${{ secrets.LOKI_URL }}

# Using specific version (pinned)
- uses: YOUR_USERNAME/github-actions-toolkit/pytest@v1.0.0
  with:
    loki_url: ${{ secrets.LOKI_URL }}

# Using specific commit (for testing)
- uses: YOUR_USERNAME/github-actions-toolkit/pytest@abc123
  with:
    loki_url: ${{ secrets.LOKI_URL }}
```

### Private Repository Access

For private repositories:

```yaml
- uses: YOUR_ORG/github-actions-toolkit/pytest@v1
  with:
    loki_url: ${{ secrets.LOKI_URL }}
```

Requires:
- Repository access for the calling repository
- Or Personal Access Token (PAT) in workflow

## GitHub Marketplace Publishing

To publish to GitHub Marketplace:

1. **Prepare action.yml with branding**
   ```yaml
   branding:
     icon: 'check-circle'
     color: 'green'
   ```

2. **Create a release on GitHub**
   - Go to Releases → Draft a new release
   - Choose your tag (e.g., v1.0.0)
   - Add release notes

3. **Publish to Marketplace**
   - Check "Publish this Action to the GitHub Marketplace"
   - Select primary category
   - Add tags/keywords
   - Publish release

4. **Verification**
   - GitHub will review (usually automatic)
   - Once approved, appears in Marketplace
   - Users can discover via search

## Best Practices

### 1. Documentation

- Clear README with examples
- Document all inputs/outputs
- Include troubleshooting section
- Provide usage examples

### 2. Version Tags

- Always create semantic version tags
- Update major version tags (v1, v2) to track latest
- Never delete or move tags

### 3. Breaking Changes

- Increment major version for breaking changes
- Document migration path in CHANGELOG
- Provide deprecation warnings

### 4. Testing

- Test actions in a separate repository
- Create example workflows
- Use matrix testing for multiple versions

### 5. Security

- Use Dependabot for dependency updates
- Pin action versions in examples
- Document security considerations

## Maintaining Published Actions

### Updating Actions

```bash
# Make changes
git add .
git commit -m "feat: add new feature"

# Create new version
git tag -a v1.1.0 -m "Add new feature"
git tag -fa v1 -m "Update v1 to v1.1.0"
git push origin v1.1.0
git push origin v1 --force
```

### Deprecating Actions

Add to README:

```markdown
## Deprecated Actions

- **action-name** - Deprecated in v2.0.0, use `new-action-name` instead
```

### Security Updates

For critical security fixes:

```bash
# Patch all major versions
git checkout v1
git cherry-pick <security-fix-commit>
git tag -a v1.0.1 -m "Security fix"
git push origin v1.0.1

git checkout v2
git cherry-pick <security-fix-commit>
git tag -a v2.0.1 -m "Security fix"
git push origin v2.0.1
```

## Monitoring Usage

### GitHub Insights

- Repository → Insights → Traffic
- See clone counts, visitor stats
- Track action usage

### Dependabot Alerts

Enable Dependabot to:
- Alert on vulnerable dependencies
- Automatically create PRs for updates

## Support & Community

### Issues

- Enable GitHub Issues
- Use issue templates
- Label and triage regularly

### Discussions

- Enable GitHub Discussions
- Q&A, Ideas, Show and tell
- Build community

### Contributing

Create CONTRIBUTING.md:

```markdown
# Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Add tests
5. Submit PR
```

## Troubleshooting

### Action not found

- Check repository is public (or accessible)
- Verify tag exists: `git tag -l`
- Check path is correct

### Permission denied

- For private repos, add repo to organization secrets
- Use PAT with repo scope

### Version not updating

- Clear GitHub Actions cache
- Force update version tag
- Wait a few minutes for GitHub to sync

## Example Workflow

Complete example of using published actions:

```yaml
name: Complete CI Pipeline

on: [push, pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: YOUR_USERNAME/github-actions-toolkit/ruff-check@v1
        with:
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}

      - uses: YOUR_USERNAME/github-actions-toolkit/mypy@v1
        with:
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: YOUR_USERNAME/github-actions-toolkit/pytest@v1
        with:
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}
```

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Creating Actions](https://docs.github.com/en/actions/creating-actions)
- [Publishing Actions](https://docs.github.com/en/actions/creating-actions/publishing-actions-in-github-marketplace)
- [Semantic Versioning](https://semver.org/)

## Quick Commands Reference

```bash
# Create new version
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# Update major version pointer
git tag -fa v1 -m "Update v1 to v1.0.0"
git push origin v1 --force

# List all tags
git tag -l

# Delete a tag (local and remote)
git tag -d v1.0.0
git push origin :refs/tags/v1.0.0

# View tag details
git show v1.0.0
```
