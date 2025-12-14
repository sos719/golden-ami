#!/usr/bin/env bash
set -euo pipefail

echo "Validating Golden AMI..."

# CHECK Marker file exists
test -f /etc/golden_ami_built
echo "Marker:"
cat /etc/golden_ami_built

# CHECK Metadata exists + valid JSON
test -f /etc/golden_ami_metadata.json
jq . /etc/golden_ami_metadata.json >/dev/null
echo "Metadata JSON valid."

# CHECK jq installed
jq --version

# CHECK Automatic updates enabled + active
systemctl is-enabled dnf-automatic.timer
systemctl is-active dnf-automatic.timer
echo "dnf-automatic.timer enabled and active."

# CHECK OpenSCAP installed
oscap --version

# Verify SCAP Security Guide content exists (common locations)
if ls /usr/share/xml/scap/ssg/content/* >/dev/null 2>&1; then
  echo "SSG content present in /usr/share/xml/scap/ssg/content/"
elif ls /usr/share/scap-security-guide/* >/dev/null 2>&1; then
  echo "SSG content present in /usr/share/scap-security-guide/"
else
  echo "ERROR: SCAP Security Guide content not found"
  exit 1
fi

echo "Validation of AMI complete. AMI IS GOOD TO GO"
