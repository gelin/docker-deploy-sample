FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y nginx

ADD nginx.conf /etc/nginx/

EXPOSE 80

VOLUME /etc/nginx

CMD ["/usr/sbin/nginx"]
