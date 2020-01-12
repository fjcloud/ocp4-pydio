# handle certificate and downloads in another stage to reduce image size
FROM image-registry.openshift-image-registry.svc:5000/openshift/rhel-minimal:latest

RUN mkdir -p /app/pydio

WORKDIR /app/pydio

COPY docker-entrypoint.sh /app/pydio/docker-entrypoint.sh
COPY libdl.so.2 /app/pydio/libdl.so.2

RUN curl "https://download.pydio.com/pub/cells/release/1.6.1/linux-amd64/cells" -o cells \
    && curl "https://download.pydio.com/pub/cells/release/1.6.1/linux-amd64/cells-ctl" -o cells-ctl \
    && chmod +x /app/pydio/cells \
    && chmod +x /app/pydio/cells-ctl \
    && ln -s /app/pydio/cells /bin/cells \
    && ln -s /app/pydio/cells-ctl /bin/cells-ctl \
    && ln -s /app/pydio/libdl.so.2 /lib64/libdl.so.2 \
    && ln -s /app/pydio/docker-entrypoint.sh /bin/docker-entrypoint.sh \
    && chmod +x /app/pydio/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["cells", "start"]
