FROM resin/rpi-raspbian:jessie
MAINTAINER Emmanuel B. <emmanuel.b+dockerhub@gmail.com>

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
      curl \
      git \
      build-essential \
      gcc \
      python \
      python-dev \
      python-pip \
      python-setuptools \
      libyaml-dev \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/*  \
    && rm -rf /var/lib/apt/lists/*

# Installs WiringPi to allow relay control
RUN pip install pyserial \
    && git clone git://git.drogon.net/wiringPi \
    && cd wiringPi && ./build \
    && pip install wiringpi2

# Gets Octoprint
ENV OCTOPRINT_RELEASE_VERSION 1.3.1rc2
RUN curl -L -o /tmp/octoprint.tar.gz https://github.com/foosel/OctoPrint/archive/$OCTOPRINT_RELEASE_VERSION.tar.gz \
    && tar xfz /tmp/octoprint.tar.gz \
    && rm -r /tmp/octoprint.tar.gz \
    && mv OctoPrint-$OCTOPRINT_RELEASE_VERSION /octoprint

# Installs Octoprint
WORKDIR /octoprint
RUN pip install pip --upgrade && \
    pip install -r requirements.txt && \
    python setup.py install
RUN mkdir /data

VOLUME /data
EXPOSE 5000

CMD ["octoprint", "serve", "--iknowwhatimdoing", "--basedir", "/data"]