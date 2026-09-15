#!/usr/bin/env bash
set -euo pipefail

MANIFEST_DIR="${1:-apps/hello}"

echo "========================================"
echo " Kubernetes Manifest Validation"
echo "========================================"
echo "Directory: $MANIFEST_DIR"
echo

# Make sure kubectl exists
if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: kubectl not found"
    exit 1
fi

# Make sure cluster is reachable
echo "==> Checking Kubernetes cluster..."
if ! kubectl cluster-info >/dev/null 2>&1; then
    echo "ERROR: Kubernetes cluster is not reachable"
    exit 1
fi

echo "✓ Cluster reachable"
echo

# Show files being checked
echo "==> YAML files:"
find "$MANIFEST_DIR" \
    -type f \
    \( -name "*.yaml" -o -name "*.yml" \) \
    -print

echo

# Let the real Kubernetes API validate the manifests
echo "==> Validating manifests..."

kubectl apply \
    --dry-run=server \
    -f "$MANIFEST_DIR"

echo
echo "========================================"
echo "✓ All manifests passed validation"
echo "========================================"