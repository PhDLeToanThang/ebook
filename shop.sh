#!/bin/bash
clear
cd ~

############### Tham số cần thay đổi ở đây ###################
echo "FQDN: e.g: demo.company.vn"   # Đổi địa chỉ web thứ nhất Website Master for Resource code - để tạo cùng 1 Source code duy nhất 
read -e FQDN
echo "dbname: e.g: nopcommercedata"   # Tên DBNane
read -e dbname
echo "dbuser: e.g: userdata"   # Tên User access DB nopcommerceuser
read -e dbuser
echo "Database Password: e.g: P@$$w0rd-1.22"
read -s dbpass
echo "phpmyadmin folder name: e.g: phpmyadmin"   # Đổi tên thư mục phpmyadmin khi add link symbol vào Website 
read -e phpmyadmin
echo "nopcommerce Folder Data: e.g: nopcommercedata"   # Tên Thư mục Data vs Cache
read -e FOLDERDATA
echo "dbtype name: e.g: mariadb"   # Tên kiểu Database
read -e dbtype
echo "dbhost name: e.g: localhost"   # Tên Db host connector
read -e dbhost

#https://github.com/nopSolutions/nopCommerce/releases/download/release-4.60.4/nopCommerce_4.60.4_NoSource_linux_x64.zip
Gitnopcommerceversion="4.60.4"

# https://www.cloudbooklet.com/install-nopcommerce-on-ubuntu-20-04-mysql-nginx-ssl/
sudo apt update -y
sudo apt dist-upgrade -y
sudo apt install unzip -y
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update -y
sudo apt install php8.0-fpm php8.0-common php8.0-mbstring php8.0-xmlrpc php8.0-soap php8.0-gd php8.0-xml php8.0-intl php8.0-mysql php8.0-cli php8.0-mcrypt php8.0-ldap php8.0-zip php8.0-curl php8.0-bz2 -y
sudo apt install mysql-server mysql-client -y

sudo systemctl stop mysql.service 
sudo systemctl start mysql.service 
sudo systemctl enable mysql.service

#Run the following command to secure MariaDB installation.
sudo mysql_secure_installation

#Step 1: Create a New nopCommerce Database Login to MySQL.
mysql -uroot -prootpassword -e "CREATE DATABASE $dbname CHARACTER SET utf8 COLLATE utf8_unicode_ci";
mysql -uroot -prootpassword -e "CREATE USER '$dbuser'@'$dbhost' IDENTIFIED BY '$dbpass'";
mysql -uroot -prootpassword -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'$dbhost'";
mysql -uroot -prootpassword -e "FLUSH PRIVILEGES";
mysql -uroot -prootpassword -e "SHOW DATABASES";

#Step 2: Install ASP.NET Core
#For nopCommerce it to run on, you need to install .NET (dot net) Core. But first, add the Microsoft package signing key to your server and install the necessary dependencies.
#Download the Ubuntu 20.04 Microsoft Package Key.

cd /opt
sudo apt-get -y install wget
sudo wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

#Install it on the server.
sudo dpkg -i packages-microsoft-prod.deb
sudo rm packages-microsoft-prod.deb
#Then, update the server.
sudo apt update -y

#Install aptitude transport for HTTPS downloads.
sudo apt install apt-transport-https -y

# Now, Install .NET Core runtime.
sudo apt install aspnetcore-runtime-6.0 -y

#Verify the installation.
dotnet --list-runtimes

#Output:
#Microsoft.AspNetCore.App 6.0.3 [/usr/share/dotnet/shared/Microsoft.AspNetCore.App]
#Microsoft.NETCore.App 6.0.3 [/usr/share/dotnet/shared/Microsoft.NETCore.App]

#Step 3: Install nopCommerce
# Create the nopCommerce webroot directory. Replace $FQDN with your subdomain or preferred naming style.
sudo mkdir /var/www
sudo mkdir /var/www/$FQDN
# Now, switch to the directory.
cd /var/www/$FQDN
# Then, download the latest nopCommerce stable release from its GitHub repository. In this guide, release-$Gitnopcommerceversion is installed. Consider downloading the latest file.
sudo wget https://github.com/nopSolutions/nopCommerce/releases/download/release-$Gitnopcommerceversion/nopCommerce_$Gitnopcommerceversion_NoSource_linux_x64.zip
# Extract files from the Zip archive.
sudo unzip nopCommerce_$Gitnopcommerceversion_NoSource_linux_x64.zip
# To save space, delete the original zip archive.
rm nopCommerce_$Gitnopcommerceversion_NoSource_linux_x64.zip
# Grant Nginx (running as www-data) ownership permissions to the directory.
sudo chown -R www-data:www-data /var/www/$FQDN
# All necessary files are now available on the server. Next, configure Nginx as a reverse proxy to serve these files on your subdomain.

#Configure permissions.
sudo chmod -R 755 /var/www/$FQDN
sudo chown -R www-data:www-data /var/www/$FQDN

#Step 4: Configure Nginx
sudo apt install nginx -y

# xoa cau hinh nginx site default
sudo rm -rf /etc/nginx/sites-available/default
sudo rm -rf /etc/nginx/sites-enabled/default

#Create a new Nginx virtual host file.
#Open and edit the file.
echo 'server {' >> /etc/nginx/conf.d/$FQDN.conf
echo 'listen 80;' >> /etc/nginx/conf.d/$FQDN.conf
echo '    listen [::]:80;' >> /etc/nginx/conf.d/$FQDN.conf
echo 'root /var/www/'${FQDN}/';'>> /etc/nginx/conf.d/$FQDN.conf
echo 'server_name '${FQDN}';' >> /etc/nginx/conf.d/$FQDN.conf
echo 'location / {' >> /etc/nginx/conf.d/$FQDN.conf
echo 'proxy_pass         http://localhost:5000;' >> /etc/nginx/conf.d/$FQDN.conf
echo 'proxy_http_version 1.1;' >> /etc/nginx/conf.d/$FQDN.conf
echo 'proxy_set_header   Upgrade $http_upgrade;' >> /etc/nginx/conf.d/$FQDN.conf
echo 'proxy_set_header   Connection keep-alive;' >> /etc/nginx/conf.d/$FQDN.conf
echo 'proxy_set_header   Host $host;' >> /etc/nginx/conf.d/$FQDN.conf
echo 'proxy_cache_bypass $http_upgrade;' >> /etc/nginx/conf.d/$FQDN.conf
echo 'proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;' >> /etc/nginx/conf.d/$FQDN.conf
echo 'proxy_set_header   X-Forwarded-Proto $scheme;' >> /etc/nginx/conf.d/$FQDN.conf
echo '	}' >> /etc/nginx/conf.d/$FQDN.conf
echo '}' >> /etc/nginx/conf.d/$FQDN.conf
#Save and close the file.
#Test Nginx for errors.
sudo nginx -t

#Enable the configuration by creating a symlink to sites-enabled directory. 
sudo ln -s /etc/nginx/sites-available/$FQDN.conf /etc/nginx/sites-enabled/$FQDN.conf

#Restart Nginx.
sudo service nginx restart

#Step 5: Configure nopCommerce as a Service:
#To start nopCommerce, it must be running as a service on the server. To do this, create a new service file in the systemd directory.
#Open and edit the file.
echo '[Unit]'  >> /etc/systemd/system/$FQDN.service
echo 'Description=ebook shop eCommerce application'  >> /etc/systemd/system/$FQDN.service
echo '[Service]'  >> /etc/systemd/system/$FQDN.service
echo 'WorkingDirectory=/var/www/'${FQDN}'/'  >> /etc/systemd/system/$FQDN.service
echo 'ExecStart=/usr/bin/dotnet /var/www/'${FQDN}'/Nop.Web.dll'  >> /etc/systemd/system/$FQDN.service
echo 'Restart=always'  >> /etc/systemd/system/$FQDN.service
echo 'Auto restart nopCommerce in 10 seconds if .NET crashes'  >> /etc/systemd/system/$FQDN.service
echo 'RestartSec=10'  >> /etc/systemd/system/$FQDN.service
echo 'KillSignal=SIGINT'  >> /etc/systemd/system/$FQDN.service
echo 'SyslogIdentifier=nopcommerce'  >> /etc/systemd/system/$FQDN.service
echo 'User=www-data'  >> /etc/systemd/system/$FQDN.service
echo 'Environment=ASPNETCORE_ENVIRONMENT=Production'  >> /etc/systemd/system/$FQDN.service
echo 'Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false'  >> /etc/systemd/system/$FQDN.service
echo '[Install]'  >> /etc/systemd/system/$FQDN.service
echo 'WantedBy=multi-user.target'  >> /etc/systemd/system/$FQDN.service

#Now, restart the systemd daemon.
sudo systemctl daemon-reload
#Then, enable nopCommerce to start at boot time.
sudo systemctl enable $FQDN.service
#Start nopCommerce.
sudo systemctl start $FQDN.service
#Check the current nopCommerce status.
sudo systemctl status $FQDN.service
#Restart Nginx to start serving nopCommerce on the subdomain.
sudo systemctl restart nginx

#Finally, visit your subdomain to start the nopCommerce setup process through a web browser.
#http://$FQDN
#Enter the administrator email, username, password, and country. Then, select MySQL from the drop-down list of options in the database section.
#Under Server name, enter localhost, then enter the database name, username, and password created on step 1.
#Click Install to proceed, nopCommerce will restart, and you may receive a 502 bad gateway error. Simply refresh your browser to log in and configure your online store.

#Step 6: Secure the Server
#By default, Uncomplicated Firewall (ufw) is enabled on Ubuntu 20.04, configure it to allow HTTP, HTTPS traffic on the server and block the rest.
#Allow HTTP traffic.
sudo ufw allow 80/tcp
#Allow HTTPS traffic.
sudo ufw allow 443/tcp
#Restart the firewall
sudo ufw reload

#Step 7.1 Setup and Configure PhpMyAdmin
sudo apt update -y
sudo apt install phpmyadmin -y

#Step 7.2. gỡ bỏ apache:
sudo service apache2 stop
sudo apt-get purge apache2 apache2-utils apache2.2-bin apache2-common
sudo apt-get purge apache2 apache2-utils apache2-bin apache2.2-common

sudo apt-get autoremove
whereis apache2
apache2: /etc/apache2
sudo rm -rf /etc/apache2

sudo ln -s /usr/share/phpmyadmin /var/www/$FQDN/$phpmyadmin
sudo chown -R root:root /var/lib/phpmyadmin
sudo nginx -t

#Step 7.3. Nâng cấp PhpmyAdmin lên version 5.2.1:
sudo mv /usr/share/phpmyadmin/ /usr/share/phpmyadmin.bak
sudo mkdir /usr/share/phpmyadmin/
cd /usr/share/phpmyadmin/
sudo wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.gz
sudo tar xzf phpMyAdmin-5.2.1-all-languages.tar.gz
#Once extracted, list folder.
#ls
#You should see a new folder phpMyAdmin-5.2.1-all-languages
#We want to move the contents of this folder to /usr/share/phpmyadmin
sudo mv phpMyAdmin-5.2.1-all-languages/* /usr/share/phpmyadmin
#ls /usr/share/phpmyadmin
mkdir /usr/share/phpMyAdmin/tmp   # tạo thư mục cache cho phpmyadmin 

sudo systemctl restart nginx
systemctl restart php8.0-fpm.service

#Request an SSL Certificate
#Step 8. Install Certbot.
sudo apt install certbot python3-certbot-nginx
#Request for a free Letâ€™s Encrypt SSL certificate. Replace example.com with your actual subdomain.

sudo certbot --nginx -d $FQDN
#Now, set up a new Cron job to automatically renew the SSL certificate before every 30 days of expiry.
#Open the crontab file.

sudo crontab -e
#Paste the following code:
#0 12 * * * /usr/bin/certbot renew --quiet

#Save and close the file.
#Conclusion
#Congratulations, you have installed nopCommerce on a Ubuntu 20.04 server. 
#You can further configure to meet your customer and visitor standards using ready-made themes, plugins, and language packs.
