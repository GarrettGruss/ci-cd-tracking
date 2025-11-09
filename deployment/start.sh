#!/bin/bash
set -e

echo "=========================================="
echo "Grafana Loki + Prometheus Stack Launcher"
echo "=========================================="
echo ""

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Error: docker-compose is not installed"
    echo "Please install docker-compose: https://docs.docker.com/compose/install/"
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file from template..."
    cp .env.example .env
    echo "✓ Created .env file"
    echo ""
    echo "⚠️  WARNING: Update .env file with secure passwords before deploying to production!"
    echo ""
fi

# Create dashboards directory if it doesn't exist
mkdir -p dashboards

echo "Starting monitoring stack..."
docker-compose up -d

echo ""
echo "Waiting for services to be ready..."
sleep 10

# Check service health
echo ""
echo "Checking service health..."

# Loki
if curl -s http://localhost:3100/ready > /dev/null; then
    echo "✓ Loki is ready"
else
    echo "✗ Loki is not ready"
fi

# Prometheus
if curl -s http://localhost:9090/-/healthy > /dev/null; then
    echo "✓ Prometheus is ready"
else
    echo "✗ Prometheus is not ready"
fi

# Grafana
if curl -s http://localhost:3000/api/health > /dev/null; then
    echo "✓ Grafana is ready"
else
    echo "✗ Grafana is not ready"
fi

# Pushgateway
if curl -s http://localhost:9091/-/ready > /dev/null; then
    echo "✓ Pushgateway is ready"
else
    echo "✗ Pushgateway is not ready"
fi

echo ""
echo "=========================================="
echo "Services are starting up!"
echo "=========================================="
echo ""
echo "Access the services at:"
echo ""
echo "  Grafana:      http://localhost:3000"
echo "    Username:   admin"
echo "    Password:   admin (change in .env)"
echo ""
echo "  Prometheus:   http://localhost:9090"
echo "  Loki:         http://localhost:3100"
echo "  Pushgateway:  http://localhost:9091"
echo ""
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Configure GitHub Actions secrets:"
echo "   LOKI_URL=http://your-server:3100"
echo "   LOKI_USER=         (leave empty for basic setup)"
echo "   LOKI_PASSWORD=     (leave empty for basic setup)"
echo ""
echo "2. View logs:"
echo "   docker-compose logs -f"
echo ""
echo "3. Stop services:"
echo "   docker-compose down"
echo ""
echo "4. Stop and remove data:"
echo "   docker-compose down -v"
echo ""
echo "=========================================="

# Open Grafana in browser (if supported)
if command -v xdg-open &> /dev/null; then
    echo ""
    echo "Opening Grafana in your browser..."
    sleep 2
    xdg-open http://localhost:3000 2>/dev/null || true
elif command -v open &> /dev/null; then
    echo ""
    echo "Opening Grafana in your browser..."
    sleep 2
    open http://localhost:3000 2>/dev/null || true
fi
