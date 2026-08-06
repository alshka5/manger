from flask import Flask, request, render_template_string, send_from_directory
import os

app = Flask(__name__)

# المجلد الذي سيتم حفظ الملفات فيه (مرتبط بالقرص الدائم)
UPLOAD_FOLDER = os.getenv('UPLOAD_FOLDER', './uploads')
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

HTML_TEMPLATE = '''
<!xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html>
<head><title>رفع الملفات</title></head>
<body>
    <h2>رفع أي نوع من الملفات</h2>
    <form action="/upload" method="post" enctype="multipart/form-data">
        <input type="file" name="file">
        <input type="submit" value="رفع">
    </form>
    <h3>الملفات المرفوعة:</h3>
    <ul>
        {% for file in files %}
            <li><a href="/uploads/{{ file }}">{{ file }}</a></li>
        {% endfor %}
    </ul>
</body>
</html>
'''

@app.route('/')
def index():
    files = os.listdir(app.config['UPLOAD_FOLDER'])
    return render_template_string(HTML_TEMPLATE, files=files)

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return 'لم يتم اختيار ملف', 400
    file = request.files['file']
    if file.filename == '':
        return 'اسم الملف فارغ', 400
    
    # حفظ الملف بأي امتداد كان
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
    file.save(filepath)
    return 'تم الرفع بنجاح! <a href="/">رجوع</a>'

@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
