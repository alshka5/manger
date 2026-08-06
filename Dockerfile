FROM php:8.2-fpm

# تثبيت Nginx
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# إنشاء مجلدات العمل والبيانات
RUN mkdir -p /app/data

# تحميل TinyFileManager وتسميته index.php
ADD https://raw.githubusercontent.com/prasathmani/tinyfilemanager/master/tinyfilemanager.php /app/index.php

# ضبط الملكية والصلاحيات لجميع ملفات ومجلدات /app
RUN chown -R www-data:www-data /app && chmod -R 777 /app

# إعدادات Nginx
RUN echo 'server { \
    listen 80; \
    root /app; \
    index index.php; \
    client_max_body_size 1024M; \
    location / { \
        try_files $uri $uri/ /index.php?$args; \
    } \
    location ~ \.php$ { \
        include fastcgi_params; \
        fastcgi_pass 127.0.0.1:9000; \
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; \
    } \
}' > /etc/nginx/sites-available/default

EXPOSE 80

CMD php-fpm -D && nginx -g 'daemon off;'
