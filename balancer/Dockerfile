FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y haproxy inotify-tools

ADD haproxy.cfg /etc/haproxy/
ADD bootstrap.sh /

EXPOSE 80

CMD ["/bootstrap.sh"]
