# Use a specific image for 'ubuntu:18.04':
FROM ubuntu:bionic-20181204

MAINTAINER Robin Bate Boerop <me@robinbb.com>

ARG DISABLE_SYSLOG
ARG DISABLE_SSH
ARG DISABLE_CRON

COPY . /bd_build
RUN [ "$DISABLE_SYSLOG" -eq 1 ] && rm -fr /bd_build/services/syslog-ng || true
RUN [ "$DISABLE_SSH" -eq 1 ] && rm -fr /bd_build/services/ssh || true
RUN [ "$DISABLE_CRON" -eq 1 ] && rm -fr /bd_build/services/cron || true

RUN /bd_build/prepare.sh \
    && /bd_build/system_services.sh \
    && /bd_build/utilities.sh \
    && /bd_build/cleanup.sh

ENV DEBIAN_FRONTEND="teletype" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

CMD ["/sbin/my_init"]
