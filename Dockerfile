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

RUN mkdir -p /home/pydio/app

WORKDIR /home/pydio/app

RUN curl "https://download.pydio.com/pub/cells/release/1.6.1/linux-amd64/cells" -o cells \
    && curl "https://download.pydio.com/pub/cells/release/1.6.1/linux-amd64/cells-ctl" -o cells-ctl \
    && chmod +x /home/pydio/app/cells \
    && chmod +x /home/pydio/app/cells-ctl \
    && ln -s /home/pydio/app/cells /bin/cells \
    && ln -s /home/pydio/app/cells-ctl /bin/cells-ctl

CMD ["cells", "start"]
