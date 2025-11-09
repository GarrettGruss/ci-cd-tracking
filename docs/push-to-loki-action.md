# Push to Loki Action

A reusable GitHub Actions composite action that sends job results and metadata to Grafana Loki for centralized logging and monitoring.

## Location

`.github/actions/push-to-loki/action.yml`

## Features

- Sends GitHub Actions job results to Grafana Loki
- Automatically includes standard GitHub context (workflow, job, repository, branch, run info)
- Supports custom labels and messages
- Optional basic authentication
- Runs even if previous steps fail (`if: always()`)
- Merges extra labels with standard labels

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `loki_url` | Yes | - | Loki endpoint URL (e.g., `https://loki.example.com`) |
| `loki_user` | No | `''` | Username for basic authentication |
| `loki_password` | No | `''` | Password for basic authentication |
| `job_status` | Yes | - | Job status (typically `${{ job.status }}`) |
| `extra_labels` | No | `{}` | Additional labels as JSON object |
| `message` | No | Auto-generated | Custom log message |

## Setup

### 1. Configure GitHub Secrets

Add the following secrets to your repository:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret** and add:
   - `LOKI_URL`: Your Loki endpoint (e.g., `https://loki.example.com`)
   - `LOKI_USER`: Your Loki username (if using basic auth)
   - `LOKI_PASSWORD`: Your Loki password (if using basic auth)

### 2. Use in Workflow

Add the action as a step in your workflow, typically at the end of a job.

## Usage Examples

### Basic Usage

```yaml
jobs:
  build:
    name: Build Project
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build
        run: npm run build

      - name: Push results to Loki
        if: always()
        uses: ./.github/actions/push-to-loki
        with:
          loki_url: ${{ secrets.LOKI_URL }}
          loki_user: ${{ secrets.LOKI_USER }}
          loki_password: ${{ secrets.LOKI_PASSWORD }}
          job_status: ${{ job.status }}
```