ARG IPERF_VERSION="iperf3==3.17.1-r0"
ARG ALPINE_VERSION="3.21"

FROM alpine:${ALPINE_VERSION}

ARG IPERF_VERSION
RUN set -eux \
    && apk --update --no-cache add "${IPERF_VERSION}" \
    && if [ -x /usr/bin/iperf ] && [ ! -x /usr/bin/iperf3 ]; then ln -s /usr/bin/iperf /usr/bin/iperf3; fi \
    && addgroup -g 1000 abc \
    && adduser -u 1000 -G abc -s /bin/false -D abc

ENV IPERF_VERBOSE=1

ARG TARGETPLATFORM
LABEL maintainer="Aleksandar Puharic <aleksandar@puharic.com>" \
    org.opencontainers.image.source="https://github.com/RouterZero/iperf-server" \
    org.opencontainers.image.description="Iperf3 Server ${IPERF_VERSION} - Alpine Build ${TARGETPLATFORM}" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.version="${IPERF_VERSION}"

EXPOSE 5201/tcp

USER abc

CMD ["/usr/bin/iperf3", "--server"]