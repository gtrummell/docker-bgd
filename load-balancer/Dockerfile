# Use library/nginx:alpine
FROM nginx:alpine

# Download and install consul-template, update the image.
RUN mkdir -p /tmp /etc/consul-template; \
#    apk update; \
#    apk upgrade; \
    wget -q -O /tmp/consul.zip https://releases.hashicorp.com/consul-template/0.19.4/consul-template_0.19.4_linux_amd64.zip; \
    unzip /tmp/consul.zip -d /usr/bin/

# Copy config files and templates into the config directory
COPY nginx.conf.ctmpl /etc/consul-template/nginx.conf.ctmpl
COPY consul-template-nginx.sh /root/consul-template-nginx.sh

# Expose Nginx Load Balancer port to the outside
EXPOSE 80
EXPOSE 8080

# Execute Consul-Template and have it launch Nginx
CMD ["/root/consul-template-nginx.sh"]
