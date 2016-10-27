FROM resin/rpi-raspbian:jessie
MAINTAINER Emmanuel B. <emmanuel.b+dockerhub@gmail.com>

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git-core \
    build-essential \
    gcc \
    python \
    python-dev \
    python-pip \
    python-setuptools \
    libyaml-dev

RUN apt-get clean \
    && rm -rf /tmp/* /var/tmp/*  \
    && rm -rf /var/lib/apt/lists/*

# Install WiringPi to allow relay control
# RUN pip install pyserial
# RUN git clone git://git.drogon.net/wiringPi
# RUN cd wiringPi && ./build
# RUN pip install wiringpi2

RUN adduser --system octoprint \
 && addgroup octoprint \
 && usermod -aG octoprint octoprint

RUN git clone https://github.com/foosel/OctoPrint.git /octoprint
RUN chown -R octoprint:octoprint /octoprint

WORKDIR /octoprint
RUN pip install -r requirements.txt && \
    python setup.py install && \
    mkdir /data
RUN chown octoprint:octoprint -R /octoprint /data

USER octoprint

VOLUME /data
EXPOSE 5000
CMD ["./run", "--basedir", "/data"]