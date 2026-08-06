FROM filebrowser/filebrowser:v2.30.0

# إنشاء مجلد البيانات والملفات
RUN mkdir -p /srv /database

# نسخ إعدادات افتراضية إن وجدت
EXPOSE 80

# تشغيل Filebrowser على المنفذ 80 ورابط القاعدة البيانات والتخزين
CMD ["filebrowser", "--port", "80", "--address", "0.0.0.0", "--database", "/database/filebrowser.db", "--root", "/srv"]
