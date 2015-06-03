Balancer
========

It's the Docker image which runs [Nginx](http://nginx.org) as the balancer. 

Build
-----

    docker build -t example/balancer balancer

Run
---
    
    docker run -p 80:80 -v $PWD/etc/nginx/upstreams:/etc/nginx/upstreams:ro \
        --name balancer --rm example/balancer
     
