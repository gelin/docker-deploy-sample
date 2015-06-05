FROM ubuntu:14.04

RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

RUN apt-get update
RUN apt-get install -y mongodb-org

VOLUME ["/data/db"]
WORKDIR /data

CMD ["mongod"]

EXPOSE 27017
EXPOSE 28017
