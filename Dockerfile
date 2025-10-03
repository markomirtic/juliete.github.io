# Use official PHP with Apache image
FROM php:8.2-apache

# Install required PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable Apache mod_rewrite for clean URLs
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Copy all application files to the container
COPY . .

# Create a symbolic link to serve from public directory
RUN rm -rf /var/www/html/* && \
    cp -r /var/www/html/public/* /var/www/html/ && \
    cp -r /var/www/html/assets /var/www/html/ && \
    cp -r /var/www/html/forms /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Configure Apache to serve the application
RUN echo '<Directory /var/www/html>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/habibi-eats.conf && \
    a2enconf habibi-eats

# Create a simple .htaccess for clean URLs and security
RUN echo 'RewriteEngine On\n\
# Redirect to index.html if accessing root\n\
DirectoryIndex index.html\n\
\n\
# Security headers\n\
<IfModule mod_headers.c>\n\
    Header always set X-Content-Type-Options nosniff\n\
    Header always set X-Frame-Options DENY\n\
    Header always set X-XSS-Protection "1; mode=block"\n\
</IfModule>\n\
\n\
# Cache static assets\n\
<IfModule mod_expires.c>\n\
    ExpiresActive on\n\
    ExpiresByType text/css "access plus 1 month"\n\
    ExpiresByType application/javascript "access plus 1 month"\n\
    ExpiresByType image/png "access plus 1 month"\n\
    ExpiresByType image/jpg "access plus 1 month"\n\
    ExpiresByType image/jpeg "access plus 1 month"\n\
</IfModule>' > /var/www/html/.htaccess

# Expose port 80
EXPOSE 80

# Health check to ensure the application is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Start Apache in the foreground
CMD ["apache2-foreground"]