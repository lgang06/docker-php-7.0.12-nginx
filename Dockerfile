FROM centos:6
MAINTAINER  "lugang@myhexin.com"
ADD ./src/ /usr/local/src/
ADD ./scripts /build
ADD ./conf /build/conf
RUN sh /build/build_install.sh
RUN sh /build/build_php_extension.sh
EXPOSE 22 80 9000
ENTRYPOINT /bin/bash /build/service_start.sh && /bin/bash
