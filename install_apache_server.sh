#! /bin/bash

# install httpd service
echo -e  "install httpd service...\n"
dnf install -y httpd
sleep 2

# check if httpd service is not running if so run it
if [ "$(systemctl is-active httpd)" = "inactive" ]
then
  echo -e  "Start and Enable httpd Service...\n"
  systemctl enable --now httpd
  sleep 2
fi

# configure firewall
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

if [ -d "/var/www/html/sa" ]
then
  echo "/var/www/html/sa aleardy exsist"
else
  echo "Create sa directory..."
  mkdir /var/www/html/sa
  sleep 2
fi


#Allow Override 
echo "<Directory \"/var/www/html/sa\">" > /etc/httpd/conf.d/sa.conf
echo "  AllowOverride all" >> /etc/httpd/conf.d/sa.conf
echo "</Directory>" >> /etc/httpd/conf.d/sa.conf

# Add authentication
read -p "Enter User Name: " userName
htpasswd -c /etc/myhttpdpassword ${userName}
echo -e  "AuthType Basic\nAuthName \"Private area\"\nAuthUserFile /etc/myhttpdpassword\nRequire valid-user" > /var/www/html/sa/.htaccess

# for test only
echo "<h1>Hello ${userName}</h1>" > index.html
cp index.html /var/www/html/sa/

# Restart httpd service
systemctl restart httpd