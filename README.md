# puppet-summit-2016

This repo contains some examples which were used to put together the presentation. They are provided here as in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

There are a number of different objects which we will describe and outline how to use these.

## Foreman Templates for use in creating a puppet 3.8 install from Satellite.

To test this scenario, we needed to first build a Satellite 3.8 server. The easiest way to do this was by using Satellite iteself. There are three templates which are availble which are:

| File            |      purpose                                                                                                |
|-----------------|:-----------------------------------------------------------------------------------------------------------:|
| finish.erb      | Default finish file                                                                                         |
| kickstart.erb   | Cloned from the default Satellite kickstart added override to inject the puppet.conf file                   |
| puppet.conf.erb | The puppet.conf file that will be injected when hostname is puppetmaster38 as we set in the kickstart       |

The next steps are to configure the community puppet master server which we have added some scripts to make this easier. These are run one after the other:

| File            |      purpose                                                                                                |
|-----------------|:-----------------------------------------------------------------------------------------------------------:|
| setup_puppetmaster38_step1.sh |  This  adds software, opens firewalls and contains instructions to generate capsule cert      |
| setup_puppetmaster38_step2.sh | This extracts the certificate, copies them and downlaods the foreman report processor         |

Note that these two scrips have also been combined into a single Remote Execution Job Template which can be used with the new Satellite 6.2 release. This is the file **setup_puppetmaster38_job_template.erb** 

## Installing community puppet agent onto hosts to communicate to community puppet master.

Note that for Satellite 6, we will install the puppet agent from the satellite tools repo as per the Satellite user guide. We also created a simple script **setup_puppet38_agent.sh** and a remote execution job **setup_puppet38_agent_job_template.erb** to automate this for our test environment.

## Switching puppet agent on a host to point to Satellite 6.

The final two scripts here are for switching the puppet agent on a host to point to a Satellite 6 server. There are a number of steps that the script will perform which, whilst not exhaustive for every customer scenario we suspect, seemed appropriate for our migrations:

1. - Backup the existing puppet agent modules and deployed configuration
2. - Remove the existing installation of the community puppet agent
3. - Disable the Puppet Community repository
4. - Enable, if required, the Satellite Tools repository
5. - Install new Puppet software (install Red Hat provided client from Satellite Tools)
6. - Configure the new Puppet agent software to talk to the Satellite 6 server
7. - Run once to request certificate (assume auto sign is enabled to make this faster)

Again there is a script which you can use which is named **switchpuppet_38_to_sat6.sh** and then also a remote execution job template which is called **switchpuppet_38_to_sat6_job_template.erb**.

These should help to automate the process we are going to describe in the Red Hat Summite 2016 presentation.

https://rh2016.smarteventscloud.com/connect/sessionDetail.ww?SESSION_ID=43270


