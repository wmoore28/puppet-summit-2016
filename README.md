# puppet-summit-2016

Starting a repo to keep track of the notes and the work for Summit 2016 presentation:

**Migrating an existing Puppet deployment into Satellite 6**

I am going to start setting up some systems to play around with this, initial thoughts are that we are going to use Open Puppet for this demonstration, version 3.8 (not 4) and we can migrate from a CentOS based deployment to a RHEL based deployment.

We should of course see if we can get containers into this maybe we could also pull in a RHSCL database as part of the demo below - initial thought would be to try and also show migration of a supported product.

Thinking we could setup a puppet master, with Hiera and Puppet DB - this could use the wildfly puppet forge module:

https://forge.puppetlabs.com/biemond/wildfly

Then we can migrate this to a Satellite 6 system which has a RHEL SOE and then has a JBoss EAP deployment.

Suggest we build this in the demolab so that we can both work on this at the same time.

Push all stuff up to this Git Repo.

