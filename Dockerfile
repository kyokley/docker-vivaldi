FROM debian:stable-slim

ENV HOME_DIR /home/vivaldi
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
RUN wget https://launchpadlibrarian.net/435337097/chromium-codecs-ffmpeg-extra_76.0.3809.87-0ubuntu0.16.04.1_amd64.deb -O codec.deb
RUN dpkg -i codec.deb

RUN /bin/bash /opt/vivaldi/update-widevine

RUN groupadd -g 1000 -r vivaldi && \
        useradd -u 1000 -r -g vivaldi -G audio,video vivaldi && \
        mkdir -p $HOME_DIR/Downloads $HOME_DIR/.cache/vivaldi $HOME_DIR/.config/vivaldi && \
        chown -R vivaldi:vivaldi $HOME_DIR
USER vivaldi
WORKDIR /home/vivaldi

CMD ["vivaldi"]
