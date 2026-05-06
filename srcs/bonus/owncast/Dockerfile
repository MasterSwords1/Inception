FROM debian:bookworm

RUN apt update -y && apt install -y zip wget curl ffmpeg

RUN mkdir owncast
RUN mkdir videos

RUN wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux
RUN chmod +x yt-dlp_linux

WORKDIR /owncast

RUN wget https://github.com/owncast/owncast/releases/download/v0.2.5/owncast-0.2.5-linux-64bit.zip
RUN unzip owncast-0.2.5-linux-64bit.zip

COPY ./script.sh .
COPY ./stream.sh .
RUN chmod +x ./script.sh
RUN chmod +x ./stream.sh

CMD ["./script.sh"]
