#!/bin/bash
set -e

echo "GitHub Actions Publishing Script"
echo "================================="
echo ""

# Configuration
REPO_NAME="${1:-github-actions-toolkit}"
GITHUB_USER="${2}"
VERSION="${3:-v1.0.0}"

if [ -z "$GITHUB_USER" ]; then
  echo "Usage: $0 <repo-name> <github-username> [version]"
  echo "Example: $0 github-actions-toolkit myusername v1.0.0"
  exit 1
fi

echo "Repository: $REPO_NAME"
echo "GitHub User: $GITHUB_USER"
echo "Version: $VERSION"
echo ""

# Create temporary directory
TEMP_DIR=$(mktemp -d)
echo "Creating temporary directory: $TEMP_DIR"

# Copy actions
echo "Copying actions..."
cp -r .github/actions/* "$TEMP_DIR/"
cp docs/push-to-loki-action.md "$TEMP_DIR/docs/" 2>/dev/null || mkdir -p "$TEMP_DIR/docs"
cp ACTION_REPOSITORY_README.md "$TEMP_DIR/README.md"

# Create individual action metadata
echo "Adding branding to actions..."
cd "$TEMP_DIR"

# Add branding to each action
for action_dir in */; do
  action_name=$(basename "$action_dir")
  action_file="${action_dir}action.yml"

  if [ -f "$action_file" ]; then
    # Check if branding already exists
    if ! grep -q "^branding:" "$action_file"; then
      # Add branding based on action type
      case "$action_name" in
        *test*|*pytest*|*benchmark*)
          ICON="check-circle"
          COLOR="green"
          ;;
        *security*|*scan*|*bandit*|*trivy*|*secret*)
          ICON="shield"
          COLOR="red"
          ;;
        *deploy*)
          ICON="upload-cloud"
          COLOR="blue"
          ;;
        *lint*|*format*|*ruff*|*mypy*)
          ICON="code"
          COLOR="purple"
          ;;
        *notify*)
          ICON="bell"
          COLOR="yellow"
          ;;
        *)
          ICON="activity"
          COLOR="gray"
          ;;
      esac

      # Add branding to action.yml
      echo "" >> "$action_file"
      echo "branding:" >> "$action_file"
      echo "  icon: '$ICON'" >> "$action_file"
      echo "  color: '$COLOR'" >> "$action_file"
    fi
  fi
done

# Create LICENSE
cat > LICENSE <<'EOF'
MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# Create CHANGELOG
cat > CHANGELOG.md <<EOF
# Changelog

All notable changes to this project will be documented in this file.

## [$VERSION] - $(date +%Y-%m-%d)

### Added
- Initial release with 33 reusable GitHub Actions
- Integrated Grafana Loki logging for all actions
- Comprehensive testing actions (pytest, integration, benchmark, load, mutation)
- Code quality actions (ruff, mypy, radon, vulture, cloc)
- Security scanning actions (bandit, pip-audit, trivy, gitleaks)
- Deployment actions (staging, production, database migrations)
- Validation actions (pre-commit, changelog, commitlint)
- Notification and reporting actions
- Full documentation and examples
EOF

# Initialize git repository
echo ""
echo "Initializing git repository..."
git init
git add .
git commit -m "Initial commit - $VERSION"

echo ""
echo "=========================================="
echo "Actions prepared in: $TEMP_DIR"
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Create a new GitHub repository:"
echo "   https://github.com/new"
echo "   Repository name: $REPO_NAME"
echo ""
echo "2. Push the code:"
echo "   cd $TEMP_DIR"
echo "   git remote add origin https://github.com/$GITHUB_USER/$REPO_NAME.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3. Create a release:"
echo "   git tag -a $VERSION -m 'Release $VERSION'"
echo "   git push origin $VERSION"
echo ""
echo "4. (Optional) Publish to GitHub Marketplace:"
echo "   - Go to your repository on GitHub"
echo "   - Navigate to 'Releases'"
echo "   - Click 'Draft a new release'"
echo "   - Select tag $VERSION"
echo "   - Check 'Publish this Action to the GitHub Marketplace'"
echo ""
echo "5. Use in other repositories:"
echo "   - uses: $GITHUB_USER/$REPO_NAME/<action-name>@v1"
echo ""
echo "=========================================="

# Open directory (if on supported OS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  open "$TEMP_DIR"
elif [[ "$OSTYPE" == "linux-gnu"* ]] && command -v xdg-open &> /dev/null; then
  xdg-open "$TEMP_DIR"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
  explorer "$TEMP_DIR"
fi

echo ""
echo "Directory opened in file manager (if supported)"
echo ""
