FROM php:8.1-fpm

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY composer.json composer.lock ./
RUN composer install --ignore-platform-reqs --no-interaction --no-scripts

COPY . .

RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 775 /var/www/html/storage

CMD php artisan serve --host=0.0.0.0 --port=8000
