# handle certificate and downloads in another stage to reduce image size
FROM alpine as certs

RUN apk update && apk add ca-certificates

RUN addgroup -S pydio -g 50001 && adduser -S pydio -G pydio -u 50001

USER pydio

WORKDIR /home/pydio

RUN wget "https://download.pydio.com/pub/cells/release/1.6.1/linux-amd64/cells"
RUN wget "https://download.pydio.com/pub/cells/release/1.6.1/linux-amd64/cells-ctl"

RUN chmod +x /home/pydio/cells
RUN chmod +x /home/pydio/cells-ctl

# Creates the final image
FROM busybox:glibc

RUN addgroup -S pydio -g 50001 && adduser -S pydio -G pydio -u 50001

USER pydio

WORKDIR /home/pydio

ENV CELLS_BIND 0.0.0.0:8080
ENV CELLS_EXTERNAL https://pydio.apps.ocp.msl.cloud:443

# Add necessary files
COPY docker-entrypoint.sh /home/pydio/docker-entrypoint.sh
COPY libdl.so.2 /home/pydio/libdl.so.2
COPY --from=certs /etc/ssl/certs /etc/ssl/certs
COPY --from=certs /home/pydio/cells-ctl .
COPY --from=certs /home/pydio/cells .

USER root

# Final configuration
RUN ln -s /home/pydio/cells /bin/cells \
    && ln -s /home/pydio/cells-ctl /bin/cells-ctl \
    && ln -s /home/pydio/libdl.so.2 /lib64/libdl.so.2 \
    && ln -s /home/pydio/docker-entrypoint.sh /bin/docker-entrypoint.sh \
    && chmod +x /home/pydio/docker-entrypoint.sh
    
USER pydio

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["cells", "start"]
