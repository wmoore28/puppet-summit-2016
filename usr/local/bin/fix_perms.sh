#!/bin/bash

chown -R apache: /etc/puppet/r10k/environments
restorecon -Fr /etc/puppet/r10k/environments
