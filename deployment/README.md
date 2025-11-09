# Grafana Loki + Prometheus Stack Deployment

This directory contains deployment configurations for the monitoring stack used to collect and visualize GitHub Actions metrics.

## Stack Components

- **Grafana Loki** (Port 3100) - Log aggregation and querying
- **Prometheus** (Port 9090) - Metrics collection and storage
- **Grafana** (Port 3000) - Visualization dashboard
- **Promtail** (Port 9080) - Log shipper (optional)
- **Pushgateway** (Port 9091) - Push metrics from GitHub Actions

## Quick Start

### Using Docker Compose (Recommended)

```bash
cd deployment
docker-compose up -d
```

### Access Services

- **Grafana**: http://localhost:3000
  - Username: `admin`
  - Password: `admin`

- **Prometheus**: http://localhost:9090
- **Loki**: http://localhost:3100
- **Pushgateway**: http://localhost:9091

## Configuration

### GitHub Actions Setup

Update your repository secrets:

```bash
LOKI_URL=http://your-server:3100
LOKI_USER=      # Leave empty for basic setup
LOKI_PASSWORD=  # Leave empty for basic setup
```

### Loki Configuration

Edit `loki-config.yml` to customize:
- Log retention (default: 14 days)
- Storage limits
- Ingestion rates

### Prometheus Configuration

Edit `prometheus.yml` to add scrape targets:

```yaml
scrape_configs:
  - job_name: 'my-app'
    static_configs:
      - targets: ['app:8080']
```

## Kubernetes Deployment

For Kubernetes deployments, see the `kubernetes/` directory:

```bash
kubectl apply -f kubernetes/
```

## Data Persistence

Volumes are created for:
- `loki-data` - Loki chunks and indexes
- `prometheus-data` - Prometheus time-series data
- `grafana-data` - Grafana dashboards and settings

### Backup Data

```bash
docker-compose down
docker run --rm -v deployment_loki-data:/data -v $(pwd):/backup alpine tar czf /backup/loki-backup.tar.gz /data
docker run --rm -v deployment_prometheus-data:/data -v $(pwd):/backup alpine tar czf /backup/prometheus-backup.tar.gz /data
docker run --rm -v deployment_grafana-data:/data -v $(pwd):/backup alpine tar czf /backup/grafana-backup.tar.gz /data
```

### Restore Data

```bash
docker run --rm -v deployment_loki-data:/data -v $(pwd):/backup alpine tar xzf /backup/loki-backup.tar.gz -C /
```

## Using GitHub Actions

### Push Logs to Loki

All GitHub Actions created in this project automatically push to Loki:

```yaml
- uses: ./.github/actions/pytest
  with:
    loki_url: ${{ secrets.LOKI_URL }}
    loki_user: ${{ secrets.LOKI_USER }}
    loki_password: ${{ secrets.LOKI_PASSWORD }}
```

### Push Metrics to Prometheus

Use the Pushgateway:

```yaml
- name: Push metrics
  run: |
    cat <<EOF | curl --data-binary @- http://localhost:9091/metrics/job/github_actions
    # TYPE github_actions_build_duration gauge
    github_actions_build_duration{job="build"} 123.45
    EOF
```

## Grafana Dashboards

### Import Dashboards

1. Navigate to Grafana (http://localhost:3000)
2. Login with admin/admin
3. Go to Dashboards → Import
4. Import from `dashboards/` directory

### Pre-configured Dashboards

Create dashboards in `dashboards/` directory and they'll be auto-loaded.

### Example LogQL Queries

```logql
# All GitHub Actions logs
{job="github-actions"}

# Failed jobs
{job="github-actions", status="failed"}

# Test results with coverage > 80%
{job="github-actions", test_type="pytest"} | json | coverage > 80

# Security scan results
{job="github-actions", security_tool=~"bandit|pip-audit|trivy"}

# Deployment logs
{job="github-actions", deployment_type=~"staging|production"}
```

### Example PromQL Queries

```promql
# GitHub Actions build count
sum by (workflow) (github_actions_build_info)

# Failed builds rate
rate(github_actions_failures_total[5m])

# Build duration
histogram_quantile(0.95, github_actions_build_duration_seconds)
```

## Security Considerations

### Production Deployment

For production, update the following:

1. **Change default passwords**:
   ```yaml
   environment:
     - GF_SECURITY_ADMIN_PASSWORD=your-secure-password
   ```

2. **Enable authentication for Loki**:
   ```yaml
   auth_enabled: true
   ```

3. **Use reverse proxy** (nginx/traefik) with TLS
4. **Configure firewall rules**
5. **Set up backup strategy**

### Authentication

For Loki authentication:

```yaml
# loki-config.yml
auth_enabled: true

# Add basic auth to nginx proxy
location /loki {
    auth_basic "Loki";
    auth_basic_user_file /etc/nginx/.htpasswd;
    proxy_pass http://loki:3100;
}
```

## Monitoring

### Health Checks

```bash
# Loki
curl http://localhost:3100/ready

# Prometheus
curl http://localhost:9090/-/healthy

# Grafana
curl http://localhost:3000/api/health
```

### Logs

```bash
# View all logs
docker-compose logs -f

# View specific service
docker-compose logs -f loki
```

## Troubleshooting

### Loki not receiving logs

1. Check Loki is running: `docker-compose ps loki`
2. Check logs: `docker-compose logs loki`
3. Verify endpoint: `curl http://localhost:3100/ready`
4. Test push:
   ```bash
   curl -X POST http://localhost:3100/loki/api/v1/push \
     -H "Content-Type: application/json" \
     -d '{"streams":[{"stream":{"job":"test"},"values":[["'$(date +%s)000000000'","test message"]]}]}'
   ```

### Prometheus not scraping

1. Check targets: http://localhost:9090/targets
2. Verify configuration: `docker-compose exec prometheus promtool check config /etc/prometheus/prometheus.yml`
3. Check service discovery

### Grafana datasource errors

1. Test datasource connection in Grafana
2. Verify URLs are using container names (not localhost)
3. Check network connectivity: `docker-compose exec grafana ping loki`

## Scaling

### High Availability

For HA setup:

1. Deploy multiple Loki instances with shared storage (S3/GCS)
2. Use Prometheus federation
3. Deploy Grafana with PostgreSQL backend

### Performance Tuning

#### Loki

```yaml
# Increase limits
limits_config:
  ingestion_rate_mb: 50
  ingestion_burst_size_mb: 100
```

#### Prometheus

```yaml
# Increase retention
command:
  - '--storage.tsdb.retention.time=30d'
```

## Cleanup

### Remove all containers and volumes

```bash
docker-compose down -v
```

### Remove only containers (keep data)

```bash
docker-compose down
```

## Additional Resources

- [Loki Documentation](https://grafana.com/docs/loki/latest/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/grafana/latest/)
- [LogQL Guide](https://grafana.com/docs/loki/latest/logql/)
- [PromQL Guide](https://prometheus.io/docs/prometheus/latest/querying/basics/)
