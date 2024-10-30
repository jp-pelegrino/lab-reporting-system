# Use php:7.4-fpm as the base image
FROM php:7.4-fpm

# Install necessary PHP extensions and dependencies
RUN docker-php-ext-install pdo pdo_mysql mbstring

# Set the working directory
WORKDIR /var/www

# Copy the application code into the Docker image
COPY . .

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP dependencies
RUN composer install

# Copy the .env.example file to .env
RUN cp .env.example .env

# Generate an application key
RUN php artisan key:generate

# Set the appropriate permissions
RUN chown -R www-data:www-data storage bootstrap/cache
RUN chmod -R 775 storage bootstrap/cache

# Expose port 80
EXPOSE 80

# Define the command to run the Laravel application
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]
