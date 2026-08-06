FROM php:8.2-apache

# تعطيل كل وحدات MPM ثم تفعيل mpm_prefork فقط لمنع التعارض
RUN a2dismod mpm_event mpm_worker || true \
    && a2enmod mpm_prefork rewrite

# تحميل ملف TinyFileManager وتسميته index.php
ADD https://raw.githubusercontent.com/prasathmani/tinyfilemanager/master/tinyfilemanager.php /var/www/html/index.php

# ضبط الصلاحيات
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

EXPOSE 80
