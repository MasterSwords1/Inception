FROM debian:bookworm

RUN apt update -y && apt install -y zip wget curl ffmpeg && rm -rf /var/lib/apt/lists/*

WORKDIR /owncast

RUN wget https://github.com/owncast/owncast/releases/download/v0.2.5/owncast-0.2.5-linux-64bit.zip \
    && unzip owncast-0.2.5-linux-64bit.zip \
    && rm owncast-0.2.5-linux-64bit.zip

COPY ./script.sh .
RUN chmod +x ./script.sh

EXPOSE 8000

ENTRYPOINT ["./script.sh"]
