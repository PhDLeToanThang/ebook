# ebook shopping dựa trên nguyên bản source code NopCommerce 
https://docs.nopcommerce.com/en/installation-and-upgrading/installing-nopcommerce/installing-on-linux.html 
<br>
Bạn chỉ cần cài đặt OS Linux Ubuntu 20.04 trên máy Ảo hoặc máy vật lý<br>
Sau đó mở màn Terminal / SSH-PuTTy và gõ lệnh:<br>
wget https://raw.githubusercontent.com/PhDLeToanThang/ebook/main/shop.sh<br>
<br>
Sau khi tải về file shop.sh<br>
Nhập tiếp lệnh: bash shop.sh<br>
<br>
Hệ thống CLI sẽ cần khai báo một số tham số liên quan Website ebook shop như:<br>
FQDN: e.g: demo.company.vn<br>
dbname: e.g: nopcommercedata<br>
dbuser: e.g: userdata<br>
Database Password: e.g: P@3167168w0rd-1.22<br>
phpmyadmin folder name: e.g: phpmyadmin<br>
nopcommerce Folder Data: e.g: nopcommercedata<br>
dbtype name: e.g: mysql<br>
dbhost name: e.g: localhost<br>
<br>
Sau cùng khi cài xong hệ thống sẽ cần bạn mở trình duyệt truy cập để cấu hình tài khoản Admin quản trị và các thông tin Database.

## Debug:
>> Cấu hình quản trị như thế nào để disable phần đăng ký nhận tin tức và không gửi email Verify Newsletter trong nop-commerce #7
https://github.com/PhDLeToanThang/ebook/issues/7

