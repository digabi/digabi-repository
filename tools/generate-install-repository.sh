#!/bin/sh
set -e

echo "#!/bin/sh"
echo "set -e"
echo ""
echo "# Generated at $(date '+%Y-%m-%d %H:%M:%S'), using digabi-repository package"
echo "#"
echo "# This script installs Digabi repository to your system."
echo "# Remember to check GPG signature of this file, from thisfile.asc."
echo ""
echo ""

echo "TEMPFILE=\$(mktemp)"
echo "cat > \${TEMPFILE} << EOF"
gpg -a --keyring=keyrings/digabi-archive-keyring.gpg --no-default-keyring --export 2>/dev/null
echo "EOF"
echo "apt-key add \${TEMPFILE}"
echo "rm -f \${TEMPFILE}"

echo "cat > /etc/apt/sources.list.d/digabi.list << EOF"
cat digabi.list
echo "EOF"
