#!/bin/bash
#
# Switch from Puppet Community 3.8 to the version that is supplied by Satellite 6.1 in the Satellite Tools repo.
# 
# - Backup the existing installation
# - Remove the existing installation
# - Disable the Puppet Community repository
# - Enable, if required, the Satellite Tools repository
# - Install new Puppet software
# - Configure the new Puppet software
# - Run once to request certificate

# Configuration
# Most should be fairly clear. COMMUNITYREPO needs special care. It should be an array!
BACKUPFILE="/root/backupfile_$(date +%s).tar.gz"
SATTOOLSREPO="rhel-7-server-satellite-tools-6.1-rpms"
COMMUNITYREPO=('Default_Organization_Community_Puppet_products_x86_64' 'Default_Organization_Community_Puppet_dependencies_x86_64' 'Default_Organization_Community_Puppet_PC1_x86_64')
NEWMASTER="geisha.thuisnet.lan"

if [ "${DEBUG}" ]; then
  set -x 
fi

set -e

echo "This script will replace existing Puppet Community 3.8.x installations with Puppet as supplied with Satellite 6.1."
read -n 1 -p "Are you sure you want to continue (y/N) " answer

if [ "${answer}" != "y" ]; then
  echo "Aborting..."
  exit 1
fi

echo
echo
echo "=> Backing up existing Puppet Community installation..."
tar czf ${BACKUPFILE} /var/lib/puppet /etc/puppet > /dev/null 2>&1
rc=$?
if [ ${rc} -ne 0 ]; then
    echo
    echo "  ERROR: Backup encountered a problem."
    exit 1
fi
echo
echo "   OK: Backup file is placed at ${BACKUPFILE}."
echo

echo "=> Removing existing Puppet Community 3.8 packages..."
yum -y remove puppet facter hiera ruby-shadow > /dev/null 2>&1
rm -rf /etc/puppet /var/lib/puppet
rc=$?
if [ ${rc} -ne 0 ]; then
    echo
    echo "  ERROR: Puppet packages could not be removed."
    exit 1
fi
echo
echo "   OK: Backup successful."
echo "   OK: File that were installed as dependencies have not been touched."
echo

echo "=> Enabling Satellite Tools repository..."
subscription-manager repos --enable ${SATTOOLSREPO} > /dev/null 2>&1
rc=$?
if [ ${rc} -ne 0 ]; then
    echo
    echo "  ERROR: ${SATTOOLSREPO} could not be enabled."
    exit 1
fi
echo
echo "  OK: ${SATTOOLSREPO} has been enabled"
echo

echo "=> Disabling Community Puppet repositories..."
for repo in "${COMMUNITYREPO[@]}"; do
subscription-manager repos --disable ${repo} > /dev/null 2>&1
done
rc=$?
if [ ${rc} -ne 0 ]; then
    echo
    echo "  ERROR: Community Puppet repositories could not be disabled."
    exit 1
fi
echo
echo "  OK: ${COMMUNITYREPO} has been disabled."
echo

echo "=> Installing new Puppet software as supplied by Satellite 6.1..."
yum -y install puppet
rc=$?
if [ ${rc} -ne 0 ]; then
    echo
    echo "  ERROR: Puppet could not be installed."
    exit 1
fi
echo
echo "  OK: Puppet has been installed."
echo

echo "=> Configuring new Puppet software..."
cat > /etc/puppet/puppet.conf << EOF
[main]
vardir = /var/lib/puppet
logdir = /var/log/puppet
rundir = /var/run/puppet
ssldir = \$vardir/ssl

[agent]
pluginsync      = true
environment     = production
server          = ${NEWMASTER}
EOF
if [ ${rc} -ne 0 ]; then
    echo
    echo "  ERROR: Puppet could not be configured"
    exit 1
fi
echo
echo "  OK: Puppet has been configured"
echo

echo "=> It should now be OK to start the Puppet agent on this server."
echo "   Make sure you sign the certificate on your master, too."






