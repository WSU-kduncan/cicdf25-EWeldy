FROM httpd:2.4

# An attempt to get webserv change but didn't work
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

COPY . /usr/local/apache2/htdocs/

# An attempt to get webserv change but didn't work.
CMD envsubst '${SERVER_NAME}' < /usr/local/apache2/htdocs/index.html > /usr/local/apache2/htdocs/index.html.tmp \
    && mv /usr/local/apache2/htdocs/index.html.tmp /usr/local/apache2/htdocs/index.html \
    && httpd-foreground
