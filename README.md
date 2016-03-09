# puppet-summit-2016

Starting a repo to keep track of the notes and the work for Summit 2016
presentation:

**Migrating an existing Puppet deployment into Satellite 6**

I am going to start setting up some systems to play around with this, initial
thoughts are that we are going to use Open Puppet for this demonstration,
version 3.8 (not 4) and we can migrate from a CentOS based deployment to a RHEL
based deployment.

We should of course see if we can get containers into this maybe we could also
pull in a RHSCL database as part of the demo below - initial thought would be
to try and also show migration of a supported product.

Thinking we could setup a puppet master, with Hiera and Puppet DB - this could
use the wildfly puppet forge module:

https://forge.puppetlabs.com/biemond/wildfly

Then we can migrate this to a Satellite 6 system which has a RHEL SOE and then
has a JBoss EAP deployment.

Suggest we build this in the demolab so that we can both work on this at the
same time.

Push all stuff up to this Git Repo.



Thougts MB below: 

So my initial plan with this was to do the following:

- have a Puppet 3.x deployment (on RHEL) that manages our infrastructure from
  there; I'm a little afraid of including a CentOS -> RHEL migration, we need
  to discuss that
- as we (a) started requiring support on our infrastructures management tools,
  and (b) we are implementing Satellite 6 anyway, we want to take our existing
  modules and use them in Satellite 6
- alternatively, we could point the existing puppet infrastructure to
  Satellite, but that's going to leave us with an unsupported Puppet;
  - the only reason I can think of to do this, is if you _really_ want to use
    Puppet 4;
- there are two extreme options for this, and various combinations of those two
  in between:
  - first of all, we can leave everything as-is, and still use Hiera, and still
    use r10k to manage data and code, respectively;
    - reports and facts would still need to go into Satellite 6;
    - r10k is currently not supported, but we have some docs to make that work;
    - hiera is undocumented but supported, and we have people using this in
      GPS;
  - and second, we can push everything into Satellite, use smart parameters,
    use config groups etc., to make use of everything Satellite 6 offers in
    this area
    - my Mojo doc is probably the basis for this (dedicated Puppet CV)
    - Smart parameters all the way
- the hybrid way(s) of pulling Puppet into Sat6 would revolve around using
  Hiera or r10k together with Satellite 6
  - I have a mojo doc on r10k that does this mostly
  - For hiera, we have some bugs to squash (hopefully sat62 will be out during
    summit)
  - if you want to keep your existing puppet stuff (because you have puppet 4),
    we can probably make that work (this is part of what Rich wants and part of
    what was on Bryan's list), there are some quirks, but there's also some
    information on the interwebs:
    https://groups.google.com/forum/#!topic/foreman-users/HOT9RSSmAMU
    - i have done some research around this already, unsure if we want to
      include this

So imo, the first step we need to take is to figure out what scenarios we want
to cover. It probably makes sense to cover the extreme Satellite variant (CVs
and Smart Parameters), it probably makes sense to explain Sat6's Puppet with
Hiera and r10k. Do we want to cover an 'external' Puppet 4 master and dito
clients reports and sending facts to Sat6? ENC functionality probably doesn't
work yet (afaics).


Big question: do we present with Satellite 6.2 or Satellite 6.1?
