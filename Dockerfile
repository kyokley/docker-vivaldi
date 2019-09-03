# Example usage:
#     docker run --rm -d \
#         --memory 4gb \
#         --shm-size=2g \
#         -v /etc/localtime:/etc/localtime:ro \
#         -v /tmp/.X11-unix:/tmp/.X11-unix \
#         -e DISPLAY=unix$DISPLAY \
#         --security-opt seccomp:${HOME}/chrome_sec.json \
#         --privileged \
#         --device /dev/snd \
#         -v /dev/shm:/dev/shm \
#         --device /dev/net/tun \
#         --cap-add=NET_ADMIN \
#         -v ${HOME}/.cache/vivaldi:/home/vivaldi/.cache/vivaldi \
#         -v ${HOME}/.config/vivaldi:/home/vivaldi/.config/vivaldi \
#         -v ${HOME}/.vivaldi/pki:/home/vivaldi/.pki \
#         -v ${HOME}/Downloads:/home/vivaldi/Downloads \
#         --name vivaldi \
#         kyokley/vivaldi

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
