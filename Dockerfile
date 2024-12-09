ARG IPERF_VERSION="iperf3==3.17.1-r0"

FROM scratch AS rootfs

COPY ["./rootfs/", "/"]



FROM --platform=${TARGETPLATFORM} lscr.io/linuxserver/baseimage-alpine:3.21


ARG IPERF_VERSION
RUN set -eux \
    && apk --update --no-cache add bash "${IPERF_VERSION}"

COPY --from=rootfs ["/", "/"]

EXPOSE 5201/TCP

ENV IPERF_VERBOSE=1
ENV S6_KEEP_ENV=1
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

LABEL maintainer="Aleksandar Puharic <aleksandar@puharic.com>" \
      org.opencontainers.image.source="https://github.com/RouterZero/iperf-server" \
      org.opencontainers.image.description="Iperf3 Server ${IPERF_VERSION} - Alpine Build ${TARGETPLATFORM}" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="${IPERF_VERSION}"
