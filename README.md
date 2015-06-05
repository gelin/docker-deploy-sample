Set up a sample VDS
===================

Install [Vagrant](http://www.vagrantup.com/downloads.html)
and [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
to run the sample VDS machine.

Run it.

    cd vagrant
    vagrant up

Build and push the balancer Docker image (see below).    
    
Install [Ansible](http://docs.ansible.com/intro_installation.html) 
to provision the machine.

Install all necessary packages and balancer container.

    cd ansible
    ansible-playbook playbooks/provision.yml

Balancer
========

It's the Docker image which runs [HAProxy](http://www.haproxy.org/) as the balancer.
It balances incoming HTTP request to configured set of webapps as backends.
It also correctly reloads HAProxy without breaking existing connections when the config is updated.

Based on this: https://github.com/million12/docker-haproxy

Build and push
--------------

    docker build -t example/balancer balancer
    
The image must be placed into the repository before provisioning the VDS machine.

    docker tag example/balancer 192.168.200.100:5000/example/balancer
    docker push 192.168.200.100:5000/example/balancer

Run manually
------------
    
    docker run -p 80:80 -v $PWD/etc/haproxy/:/etc/haproxy/:ro \
        --name balancer -d example/balancer

WebApp
======

Simplest WebApp with static page.
 
Build and push
--------------

    docker build -t example/webapp webapp
    
The image must be placed into the repository before provisioning the VDS machine.

    docker tag example/webapp 192.168.200.100:5000/example/webapp
    docker push 192.168.200.100:5000/example/webapp    
    
Run manually
------------

    docker run --name webapp1 -d example/webapp
    
Balancing manually
==================

You need to find out the internal IP address of the just run WebApp container.

    % docker inspect --format='{{.NetworkSettings.IPAddress}}' webapp1
    172.17.0.37
        
And add this IP to the list of backend servers of HAProxy in `etc/haproxy/haproxy.cfg` file.

    ...
    backend webapps
        server webapp1 172.17.0.37:80 check

Then HAProxy container automatically detects the config file change and starts forwarding requests to WebApp.

...

Then you deploy a new version of the WebApp as a new container.

    docker run --name webapp2 -d example/webapp
        
Take it's IP.
        
    % docker inspect --format='{{.NetworkSettings.IPAddress}}' webapp2
    172.17.0.41
        
Add it to `haproxy.cfg`, and mark `webapp1` as inactive.
        
    ...
    backend webapps
        server webapp1 172.17.0.37:80 disabled
        server webapp2 172.17.0.41:80 check
        
Now you can check that requests come to `webapp2` and not to `webapp1`
by looking to the server logs.

    docker logs -f webapp1
    docker logs -f webapp2

After some period of time, 
when the current requests to `webapp1` are completed
(they can be sticked by session, depends on HAProxy configuration),
you can stop the old WebApp and remove it's container.

    docker stop webapp1
    docker rm webapp1    

All requests now are processed by `webapp2`.
Now it's safe to remove `webapp1` from the balancing.

    ...
    backend webapps
        server webapp2 172.17.0.41:80 check

Deploying webapp
================
               
When the VDS is provisioned, balancer is installed, it's time to deploy WebApp.

Firstly, build and push the latest WebApp (see above).

Then deploy it.
               
    cd ansible
    ansible-playbook playbooks/deploy_webapp.yml
                        
Check the containers running and balancing.

    % ansible server -m setup -a "filter=ansible_local"
    10.40.20.2 | success >> {
        "ansible_facts": {
            "ansible_local": {
                "balancing_containers": {
                    "containers": [
                        {
                            "balance": "check", 
                            "id": "4e20509395de", 
                            "ip": "172.17.0.3", 
                            "name": "/dreamy_poincare"
                        }, 
                        {
                            "balance": "disabled", 
                            "id": "f0a79720ed2a", 
                            "ip": "172.17.0.2", 
                            "name": "/silly_bardeen"
                        }
                    ]
                }
            }
        }, 
        "changed": false
    }
    
The balancer is already configured correctly.
    
    
