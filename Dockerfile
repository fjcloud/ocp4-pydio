# handle certificate and downloads in another stage to reduce image size
FROM image-registry.openshift-image-registry.svc:5000/openshift/rhel-minimal:latest

RUN microdnf install http://mirror.centos.org/centos/7.7.1908/os/x86_64/Packages/shadow-utils-4.6-5.el7.x86_64.rpm /
    && useradd -rm -d /home/pydio -s /bin/bash -g root -u pydio

USER pydio

RUN mkdir -p /app/pydio

WORKDIR /app/pydio

COPY docker-entrypoint.sh /app/pydio/docker-entrypoint.sh

RUN curl "https://download.pydio.com/pub/cells/release/1.6.1/linux-amd64/cells" -o cells \
    && curl "https://download.pydio.com/pub/cells/release/1.6.1/linux-amd64/cells-ctl" -o cells-ctl \
    && chmod +x /app/pydio/cells \
    && chmod +x /app/pydio/cells-ctl \
    && ln -s /app/pydio/cells /bin/cells \
    && ln -s /app/pydio/cells-ctl /bin/cells-ctl \
    && ln -s /app/pydio/docker-entrypoint.sh /bin/docker-entrypoint.sh \
    && chmod +x /app/pydio/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["cells", "start"]
