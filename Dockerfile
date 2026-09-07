ARG IPERF_VERSION="iperf3==3.17.1-r0"
ARG ALPINE_VERSION="3.21"

FROM scratch AS rootfs

# Install s6-overlay
COPY --from=ghcr.io/n0rthernl1ghts/s6-rootfs:3.2.3.2 ["/", "/"]

COPY ["./rootfs/", "/"]



ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}


ARG IPERF_VERSION
RUN set -eux \
    && apk --update --no-cache add bash "${IPERF_VERSION}"

COPY --from=rootfs ["/", "/"]

ENV IPERF_VERBOSE=1 \
    S6_KEEP_ENV=1 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

ARG TARGETPLATFORM
LABEL maintainer="Aleksandar Puharic <aleksandar@puharic.com>" \
    org.opencontainers.image.source="https://github.com/RouterZero/iperf-server" \
    org.opencontainers.image.description="Iperf3 Server ${IPERF_VERSION} - Alpine Build ${TARGETPLATFORM}" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.version="${IPERF_VERSION}"

EXPOSE 5201/tcp

ENTRYPOINT [ "/init" ]