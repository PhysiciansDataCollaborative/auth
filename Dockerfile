# Dockerfile for the PDC's Auth service
#
# Base image
#
FROM phusion/passenger-nodejs


# Update system, install DACS
#
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'Dpkg::Options{ "--force-confdef"; "--force-confold" }' \
      >> /etc/apt/apt.conf.d/local
RUN apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y dacs


# Create startup script and make it executable
#
RUN mkdir -p /etc/service/app/
RUN ( \
      echo "#!/bin/bash"; \
      echo "#"; \
      echo "set -e -o nounset -x"; \
      echo ""; \
      echo ""; \
      echo "# If jurisdiction folder doesn't exist, then initialize DACS"; \
      echo "#"; \
      echo "if [ ! -d \${DACS_STOREDIR}/federations/\${DACS_FEDERATION}/\${DACS_JURISDICTION}/ ]"; \
      echo "then"; \
      echo "  ("; \
      echo "    mkdir -p \${DACS_STOREDIR}/federations/\${DACS_FEDERATION}/\${DACS_JURISDICTION}/"; \
      echo "    cp /app/federations/dacs.conf \${DACS_STOREDIR}/federations/"; \
      echo "    cp /app/federations/site.conf \${DACS_STOREDIR}/federations/"; \
      echo "    touch \${DACS_STOREDIR}/federations/\${DACS_FEDERATION}/roles"; \
      echo "    touch \${DACS_STOREDIR}/federations/\${DACS_FEDERATION}/federation_keyfile"; \
      echo "  )||("; \
      echo "    ERROR: DACS initialization unsuccessful >&2"; \
      echo "  )"; \
      echo "fi"; \
      echo "chown -R app:app \${DACS_STOREDIR}/"; \
      echo ""; \
      echo ""; \
      echo "# Start service"; \
      echo "#"; \
      echo "export BRANCH=\${BRANCH_AUTH}"; \
      echo "export CONTROLPORT=\${PORT_AUTH_C}"; \
      echo "export MAINPORT=\${PORT_AUTH_M}"; \
      echo "export FEDERATION=\${DACS_FEDERATION}"; \
      echo "export JURISDICTION=\${DACS_JURISDICTION}"; \
      echo "export ROLEFILE=\${DACS_ROLEFILE}"; \
      echo "export KEYFILE=\${DACS_KEYFILE}"; \
      echo "export SECRET=\${NODE_SECRET}"; \
      echo "export DACS=\${DACS_STOREDIR}"; \
      echo "#"; \
      echo ""; \
      echo ""; \
      echo "# Add a dummy user"; \
      echo "#"; \
      echo "/sbin/setuser app dacskey -uj \${DACS_JURISDICTION} -v \${DACS_STOREDIR}/federations/\${DACS_FEDERATION}/federation_keyfile"; \
      echo "/sbin/setuser app dacspasswd -uj \${JURISDICTION} -p foo -a foo || echo 'Foo already exists!'"; \
      echo "echo 'foo:admin' > \${ROLEFILE}"; \
      echo ""; \
      echo ""; \
      echo "cd /app/"; \
      echo "/sbin/setuser app npm start"; \
    )  \
      >> /etc/service/app/run
RUN chmod +x /etc/service/app/run


# Prepare /app/ and /etc/dacs/ folders
#
WORKDIR /app/
COPY . .
RUN npm install
RUN mkdir -p /etc/dacs/
RUN chown -R app:app /app/ /etc/dacs/


# Run Command
#
CMD ["/sbin/my_init"]
