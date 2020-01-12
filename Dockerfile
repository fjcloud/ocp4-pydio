# handle certificate and downloads in another stage to reduce image size
FROM image-registry.openshift-image-registry.svc:5000/openshift/rhel-minimal:latest

RUN addgroup -S pydio -g 50001 && adduser -S pydio -G pydio -u 50001

WORKDIR /home/pydio

RUN wget "https://download.pydio.com/pub/cells/release/1.6.1/linux-amd64/cells"
RUN wget "https://download.pydio.com/pub/cells/release/1.6.1/linux-amd64/cells-ctl"

RUN chmod +x /home/pydio/cells
RUN chmod +x /home/pydio/cells-ctl

ENV CELLS_BIND 0.0.0.0:8080
ENV CELLS_EXTERNAL https://pydio.apps.ocp.msl.cloud:443

# Add necessary files
COPY docker-entrypoint.sh /home/pydio/docker-entrypoint.sh
COPY libdl.so.2 /home/pydio/libdl.so.2

# Final configuration
RUN ln -s /home/pydio/cells /bin/cells \
    && ln -s /home/pydio/cells-ctl /bin/cells-ctl \
    && ln -s /home/pydio/libdl.so.2 /lib64/libdl.so.2 \
    && ln -s /home/pydio/docker-entrypoint.sh /bin/docker-entrypoint.sh \
    && chmod +x /home/pydio/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["cells", "start"]
