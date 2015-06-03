WebApp
======

Simplest WebApp with static page.
 
Build
-----

    docker build -t example/webapp webapp
    
Run
---

    docker run --name webapp -P -d example/webapp
    


Balancer
========

It's the Docker image which runs [Nginx](http://nginx.org) as the balancer. 

Build
-----

    docker build -t example/balancer balancer

Run
---
    
    docker run -p 80:80 -v $PWD/etc/nginx/upstreams:/etc/nginx/upstreams \
        --name balancer -d example/balancer
     

Manual balancing
================

Inspect the WebApp internal IP address:

    % docker inspect --format='{{.NetworkSettings.IPAddress}}' webapp
    172.17.0.14
        
Add the WebApp IP address to `upstreams` config file:
        
    upstream webapp {
        server 172.17.0.14:80;
    }
            
Notify Nginx about config file changes (TODO):
            
    % docker kill -s SIGHUP balancer
                