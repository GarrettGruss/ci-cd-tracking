# Kubernetes Deployment Guide

Deploy the Grafana Loki + Prometheus stack on Kubernetes.

## Prerequisites

- Kubernetes cluster (1.19+)
- kubectl configured
- Storage class available for PVCs

## Quick Deploy

```bash
# Deploy all components
kubectl apply -f namespace.yaml
kubectl apply -f loki.yaml
kubectl apply -f prometheus.yaml
kubectl apply -f grafana.yaml
kubectl apply -f pushgateway.yaml
```

Or use a single command:

```bash
kubectl apply -f .
```

## Verify Deployment

```bash
# Check all pods are running
kubectl get pods -n monitoring

# Check services
kubectl get svc -n monitoring

# Check PVCs
kubectl get pvc -n monitoring
```

## Access Services

### Port Forwarding (Development)

```bash
# Grafana
kubectl port-forward -n monitoring svc/grafana 3000:3000

# Prometheus
kubectl port-forward -n monitoring svc/prometheus 9090:9090

# Loki
kubectl port-forward -n monitoring svc/loki 3100:3100

# Pushgateway
kubectl port-forward -n monitoring svc/pushgateway 9091:9091
```

Then access:
- Grafana: http://localhost:3000
- Prometheus: http://localhost:9090
- Loki: http://localhost:3100

### LoadBalancer (Production)

Services are configured with LoadBalancer type. Get external IPs:

```bash
kubectl get svc -n monitoring
```

### Ingress (Recommended for Production)

Create an Ingress resource:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: monitoring-ingress
  namespace: monitoring
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
  - hosts:
    - grafana.example.com
    - prometheus.example.com
    - loki.example.com
    secretName: monitoring-tls
  rules:
  - host: grafana.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: grafana
            port:
              number: 3000
  - host: prometheus.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: prometheus
            port:
              number: 9090
  - host: loki.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: loki
            port:
              number: 3100
```

## Configuration

### Storage

By default, uses PersistentVolumeClaims. Adjust storage size in each YAML:

```yaml
spec:
  resources:
    requests:
      storage: 20Gi  # Change this
```

### Resource Limits

Adjust in each deployment:

```yaml
resources:
  requests:
    memory: "512Mi"
    cpu: "200m"
  limits:
    memory: "1Gi"
    cpu: "1000m"
```

### Grafana Admin Password

Change in `grafana.yaml`:

```yaml
env:
- name: GF_SECURITY_ADMIN_PASSWORD
  value: "your-secure-password"
```

Or use a Secret:

```yaml
- name: GF_SECURITY_ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: grafana-secrets
      key: admin-password
```

## High Availability

### Loki HA

For HA Loki, use S3/GCS backend:

```yaml
common:
  storage:
    s3:
      s3: s3://region/bucket
      endpoint: s3.amazonaws.com
```

Then scale replicas:

```bash
kubectl scale deployment loki -n monitoring --replicas=3
```

### Prometheus HA

Deploy multiple Prometheus instances with Thanos:

```bash
# See Thanos documentation
# https://thanos.io/
```

## Monitoring

```bash
# View logs
kubectl logs -n monitoring deployment/loki -f
kubectl logs -n monitoring deployment/prometheus -f
kubectl logs -n monitoring deployment/grafana -f

# Check events
kubectl get events -n monitoring --sort-by='.lastTimestamp'

# Describe pods
kubectl describe pod -n monitoring <pod-name>
```

## Backup

### Backup PVCs

```bash
# Loki
kubectl exec -n monitoring deployment/loki -- tar czf - /loki > loki-backup.tar.gz

# Prometheus
kubectl exec -n monitoring deployment/prometheus -- tar czf - /prometheus > prometheus-backup.tar.gz

# Grafana
kubectl exec -n monitoring deployment/grafana -- tar czf - /var/lib/grafana > grafana-backup.tar.gz
```

### Restore

```bash
# Restore Loki
cat loki-backup.tar.gz | kubectl exec -i -n monitoring deployment/loki -- tar xzf - -C /
kubectl rollout restart deployment/loki -n monitoring
```

## Cleanup

```bash
# Delete all resources
kubectl delete -f .

# Delete namespace and all resources
kubectl delete namespace monitoring
```

## Troubleshooting

### Pods not starting

```bash
# Check pod status
kubectl describe pod -n monitoring <pod-name>

# Check logs
kubectl logs -n monitoring <pod-name>

# Check events
kubectl get events -n monitoring
```

### PVC pending

```bash
# Check storage class
kubectl get storageclass

# Describe PVC
kubectl describe pvc -n monitoring <pvc-name>
```

### Service not accessible

```bash
# Check service
kubectl get svc -n monitoring <service-name>

# Check endpoints
kubectl get endpoints -n monitoring <service-name>

# Test from within cluster
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- sh
curl http://loki.monitoring.svc.cluster.local:3100/ready
```

## Production Checklist

- [ ] Change default passwords
- [ ] Configure TLS/Ingress
- [ ] Set up proper storage classes with backups
- [ ] Configure resource limits based on load
- [ ] Set up monitoring alerts
- [ ] Enable authentication for Loki
- [ ] Configure retention policies
- [ ] Set up log rotation
- [ ] Document backup/restore procedures
- [ ] Configure network policies
- [ ] Set up RBAC

## Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Grafana on Kubernetes](https://grafana.com/docs/grafana/latest/setup-grafana/installation/kubernetes/)
- [Loki on Kubernetes](https://grafana.com/docs/loki/latest/installation/kubernetes/)
- [Prometheus on Kubernetes](https://prometheus.io/docs/prometheus/latest/installation/)
