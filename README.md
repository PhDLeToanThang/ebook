# ebook shopping dựa trên nguyên bản source code NopCommerce 
https://docs.nopcommerce.com/en/installation-and-upgrading/installing-nopcommerce/installing-on-linux.html 

Bạn chỉ cần cài đặt OS Linux Ubuntu 20.04 trên máy Ảo hoặc máy vật lý
Sau đó mở màn Terminal / SSH-PuTTy và gõ lệnh:<br>
wget https://raw.githubusercontent.com/PhDLeToanThang/ebook/main/shop.sh<br>

Sau khi tải về file shop.sh
Nhập tiếp lệnh: bash shop.sh

Hệ thống CLI sẽ cần khai báo một số tham số liên quan Website ebook shop như:
FQDN: e.g: demo.company.vn
dbname: e.g: nopcommercedata
dbuser: e.g: userdata
Database Password: e.g: P@3167168w0rd-1.22
phpmyadmin folder name: e.g: phpmyadmin
nopcommerce Folder Data: e.g: nopcommercedata
dbtype name: e.g: mysql
dbhost name: e.g: localhost

Sau cùng khi cài xong hệ thống sẽ cần bạn mở trình duyệt truy cập để cấu hình tài khoản Admin quản trị và các thông tin Database.
