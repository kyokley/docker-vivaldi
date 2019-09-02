FROM debian:stable-slim

RUN apt-get update && \
        apt-get install -y wget \
                           fonts-liberation \
                           libappindicator3-1 \
                           libasound2 \
                           xdg-utils \
                           libxrender1 \
                           libxss1 \
                           libnss3 \
                           libnspr4

WORKDIR /root
RUN wget https://downloads.vivaldi.com/stable/vivaldi-stable_2.7.1628.30-1_amd64.deb -O vivaldi.deb
RUN dpkg -i vivaldi.deb
