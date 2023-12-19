FROM ubuntu:latest

WORKDIR /project

RUN apt-get update &&  apt-get install  -y nano tar gzip zip cron

RUN mkdir -p /opt/backups
RUN touch /opt/log.txt


COPY scripts/ /project/scripts/

COPY . .

RUN mkdir -p /project/databases /project/admins
RUN touch /project/admins/admins.txt

EXPOSE 4000