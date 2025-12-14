#!/usr/bin/env bash
set -euo pipefail

# Patch OS, install baseline tools (jq + security scanner OpenSCAP) and setup automatic updates
sudo dnf -y update
sudo dnf -y install jq dnf-automatic openscap-scanner scap-security-guide

# Enable automatic updates (dnf-automatic)
sudo sed -i 's/^apply_updates\s*=.*/apply_updates = yes/' /etc/dnf/automatic.conf || true
sudo systemctl enable --now dnf-automatic.timer

# Marker + metadata for validation/demo
BUILD_TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

echo "Golden AMI built at ${BUILD_TS}" | sudo tee /etc/golden_ami_built >/dev/null
sudo chmod 644 /etc/golden_ami_built

cat <<EOF | sudo tee /etc/golden_ami_metadata.json >/dev/null
{
  "built_at_utc": "${BUILD_TS}",
  "features": {
    "jq_installed": true,
    "dnf_automatic_enabled": true,
    "openscap_installed": true,
    "scap_security_guide_installed": true
  }
}
EOF
sudo chmod 644 /etc/golden_ami_metadata.json

echo "Patch/config complete."