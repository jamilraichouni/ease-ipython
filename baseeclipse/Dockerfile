ARG BASE_IMAGE
ARG BUILD_TYPE=online
FROM ${BASE_IMAGE} AS bullseye
COPY entrypoint.sh /
COPY gdbextension.py /root
COPY .gdbinit /root

# install system packages
RUN apt-get update && \
  apt-get install -y \
  curl \
  dbus-x11 \
  gdb \
  libswt-gtk-4-java \
  procps \
  vim \
  xvfb

ENV DISPLAY=:99

# install python and some python packages
RUN apt-get install -y python3 python3-dbg python3-pip && \
  ln -s /usr/bin/python3 /usr/local/bin/python && \
  pip install ipykernel jupyter

RUN rm -rf /var/lib/apt/lists/*

# install eclipse
FROM bullseye as build_offline
ONBUILD ADD eclipse.tar.gz /opt

FROM bullseye as build_online
ONBUILD RUN curl \
  https://mirror.dkm.cz/eclipse/technology/epp/downloads/release/2022-09/R/eclipse-modeling-2022-09-R-linux-gtk-x86_64.tar.gz \
  --output eclipse.tar.gz && \
  tar -xvf eclipse.tar.gz && \
  mv eclipse /opt && \
  rm eclipse.tar.gz

FROM build_${BUILD_TYPE}
RUN ln -s /opt/eclipse/eclipse /usr/local/bin/eclipse && mkdir /tmp/workspace
ENTRYPOINT [ "/entrypoint.sh" ]
WORKDIR /tmp
