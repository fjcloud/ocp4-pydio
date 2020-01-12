# handle certificate and downloads in another stage to reduce image size
FROM image-registry.openshift-image-registry.svc:5000/openshift/rhel-minimal:latest

RUN curl http://mirror.centos.org/centos/7.7.1908/os/x86_64/Packages/shadow-utils-4.6-5.el7.x86_64.rpm \
    -o /tmp/shadow-utils-4.6-5.el7.x86_64.rpm \
    && curl http://mirror.centos.org/centos/7.7.1908/os/x86_64/Packages/libsemanage-2.5-14.el7.x86_64.rpm \
    -o /tmp/libsemanage-2.5-14.el7.x86_64.rpm \
    && curl http://mirror.centos.org/centos/6/os/x86_64/Packages/ustr-1.0.4-9.1.el6.x86_64.rpm \
    -o /tmp/ustr-1.0.4-9.1.el6.x86_64.rpm \
    && rpm -i /tmp/ustr-1.0.4-9.1.el6.x86_64.rpm \
    && rpm -i /tmp/libsemanage-2.5-14.el7.x86_64.rpm \
    && rpm -i /tmp/shadow-utils-4.6-5.el7.x86_64.rpm \
    && useradd -rm -d /home/pydio -s /bin/bash -g root -u 5001 pydio

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
