#!/bin/bash

master="PUPPETMASTER"

echo "=> Installing Puppet Agent 3.8..."
yum -q -y install puppet

echo
echo "=> Configuring Puppet to connect to master..."
cat > /etc/puppet/puppet.conf << EOF
[main]
vardir = /var/lib/puppet
logdir = /var/log/puppet
rundir = /var/run/puppet
ssldir = \$vardir/ssl

[agent]
pluginsync      = true
environment     = production
server          = ${master}
EOF

echo
echo "=> Starting and enabling Puppet Agent..."
systemctl start puppet
systemctl enable puppet

echo "=> FINAL STEP: Log into your Puppet master and sign the certificate for this host."
exit 0
