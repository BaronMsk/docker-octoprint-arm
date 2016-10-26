FROM resin/rpi-raspbian:jessie
MAINTAINER Emmanuel B. <manubing@gmail.com>

# Install dependencies
RUN apt-get update && apt-get install -y \
    git-core \
    build-essential \
    gcc \
    python \
    python-dev \
    python-pip \
    python-virtualenv \
    python-setuptools \
    libyaml-dev \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Creates a deploy user
RUN useradd --create-home -G tty,dialout --shell /bin/bash pi
RUN echo "pi ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER pi
WORKDIR /home/pi

RUN git clone https://github.com/foosel/OctoPrint.git && \
    cd OctoPrint && \
    virtualenv venv && \
    ./venv/bin/pip install pip --upgrade && \
    ./venv/bin/python setup.py install && \
    mkdir ~/.octoprint && \

# RUN pip install pyserial
# RUN git clone git://git.drogon.net/wiringPi
# RUN cd wiringPi && ./build
# RUN pip install wiringpi2

# # Define working directory
# WORKDIR /data

VOLUME /home/pi/.octoprint /dev/ttyOCT0

CMD ["/home/pi/OctoPrint/venv/bin/octoprint"]