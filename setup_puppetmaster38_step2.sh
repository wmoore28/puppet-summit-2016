#!/bin/bash

myfile="/root/$(hostname -f).tar"

satserver="$(awk ' /^hostname/ { print $3} ' /etc/rhsm/rhsm.conf)"
if [ -z "${satserver}" ]; then
    echo "=> ERROR: Cannot determine Satellite server."
    exit 1
fi

rpm -q wget > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "=> ERROR: wget is not installed."
    exit 1
fi

echo "=> Did you copy over the file I asked for?"
test -f ${myfile}
if [ $? -ne 0 ]; then
    echo "   No, you didn't. Bye now."
else
    echo "   Thanks. Continuing..."
fi

echo
echo "=> Extracting the Puppet certificate..."
tar xf ${myfile}
cd /root/ssl-build
rpm2cpio katello-default-ca-1.0-1.noarch.rpm | cpio -idmv
cd /root/ssl-build/$(hostname -f)
rpm2cpio $(hostname -f)-puppet-client-1.0-1.noarch.rpm | cpio -idmv

echo
echo "=> Installing the certificates in the right locations..."
mkdir -p /etc/puppet/foreman
cp etc/pki/katello-certs-tools/certs/$(hostname -f)-puppet-client.crt /etc/puppet/foreman
cp etc/pki/katello-certs-tools/private/$(hostname -f)-puppet-client.key /etc/puppet/foreman
cp ../etc/pki/katello-certs-tools/certs/katello-default-ca.crt /etc/puppet/foreman
chmod 640 /etc/puppet/foreman/*
chown root:puppet /etc/puppet/foreman/*

echo
echo "=> Downloading Foreman report processor..."
wget -q https://raw.githubusercontent.com/theforeman/puppet-foreman/e14c941a2d543f7ba4144ecda5bb6aec4335bb6d/files/foreman-report_v2.rb -O /usr/share/ruby/vendor_ruby/puppet/reports/foreman.rb

echo
echo "=> Configuring Puppet master to report to Satellite 6..."
cat > /etc/puppet/foreman.yaml << EOF
---
:url: "https://${satserver}"
:ssl_ca: "/etc/puppet/foreman/katello-default-ca.crt"
:ssl_cert: "/etc/puppet/foreman/$(hostname -f)-puppet-client.crt"
:ssl_key: "/etc/puppet/foreman/$(hostname -f)-puppet-client.key"

:puppetdir: "/var/lib/puppet"
:puppetuser: "puppet"
:facts: true
:timeout: 10
:threads: null
EOF
sed -i '/\[main\]/a     reports = log, foreman' /etc/puppet/puppet.conf

cat >> /etc/puppet/puppet.conf << EOF
[master]
    environmentpath = /etc/puppet/environments
    basemodulepath = /etc/puppet/environments/common:/etc/puppet/modules:/usr/share/puppet/modules
EOF

echo
echo "=> Restarting Puppet master process..."
systemctl restart puppetmaster

echo
echo "=> FINAL STEP:"
echo "   Log into your Satellite server and add $(hostname -f) to the list of "
echo "   'Trusted puppetmaster hosts' under Settings -> Auth."
echo "   This setting is an array, so keep the [] in tact."
echo
