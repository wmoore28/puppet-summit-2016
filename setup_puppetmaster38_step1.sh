#!/bin/bash

echo "=> Installing software..."
yum -y -q install puppet-server

echo
echo "=> Opening up firewall for Puppet protocol..."
firewall-cmd --add-port=8140/tcp
firewall-cmd --add-port=8140/tcp --permanent

echo
echo "=> Starting and enabling puppetmaster service..."
systemctl enable puppetmaster
systemctl start puppetmaster

echo
echo "Now, on the Satellite server, run:"
echo "# capsule-certs-generate --node-fqdn $(hostname -f) --certs-tar ~/$(hostname -f).tar"
echo
echo "Afterwards, copy that file over to /root/$(hostname -f).tar and run:"
echo "# cd $HOME; ./setup_puppetmaster38_step2.sh"
echo
exit 1
