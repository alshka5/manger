FROM php:8.2-fpm

# تثبيت خادم Nginx
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# إنشاء مجلد التطبيق وتحميل TinyFileManager
RUN mkdir -p /app/data
ADD https://raw.githubusercontent.com/prasathmani/tinyfilemanager/master/tinyfilemanager.php /app/index.php

# ضبط إعدادات Nginx لتشغيل PHP
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

# تشغيل php-fpm و nginx معاً
CMD php-fpm -D && nginx -g 'daemon off;'
