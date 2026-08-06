FROM php:8.2-apache

# تفعيل موديل تحويل المسارات في أباتشي
RUN a2enmod rewrite

# تحميل أحدث نسخة من TinyFileManager وتسميتها index.php
ADD https://raw.githubusercontent.com/prasathmani/tinyfilemanager/master/tinyfilemanager.php /var/www/html/index.php

# ضبط الصلاحيات للمجلد
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# تغيير المنفذ ليتوافق مع Railway
EXPOSE 80
