# Build from httpd:2.4
FROM httpd:2.4

# Copy all web content into Apache's default directory
COPY web-content/ /usr/local/apache2/htdocs/
