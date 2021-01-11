FROM java:latest

ENV LIQUIBASE_VERSION="3.6.2"

RUN set -x \
    && rm -f /etc/apt/sources.list.d/jessie-backports.list \
    && apt-get update \
	  && apt-get install -yq --no-install-recommends libmysql-java python3 python3-pip \
	  && pip3 install 'pyentrypoint==0.7.1'

RUN wget -q -O/tmp/liquibase.tar.gz "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}-bin.tar.gz" \
    && mkdir -p /opt/liquibase \
    && tar -xzf /tmp/liquibase.tar.gz -C /opt/liquibase \
    && rm -f /tmp/liquibase.tar.gz \
    && chmod +x /opt/liquibase/liquibase \
    && wget -q -O/opt/liquibase/lib/slf4j-api-1.7.25.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar \
    && ln -s /opt/liquibase/liquibase /usr/local/bin/ \
	  && apt-get clean \
	  && rm -r /var/lib/apt/lists/* \
    && mkdir /liquibase \
    # cleanup
    && apt-get autoremove -y -f \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/liquibase

COPY . .

WORKDIR /liquibase

COPY entrypoint-config.yml .

ENTRYPOINT ["pyentrypoint"]

CMD ["/usr/local/bin/liquibase"]
