FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y nginx

ADD nginx.conf /etc/nginx/
ADD index.html /www/

EXPOSE 80

VOLUME /www

CMD ["/usr/sbin/nginx"]
