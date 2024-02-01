# HTTPD Installation and Configuration Script

This Bash script automates the installation and configuration of the Apache HTTP server with basic authentication and firewall settings. Follow the steps below to use the script:

## Instructions:

1. **Install HTTPD Service:**

   - Run `dnf install -y httpd`.

2. **Check and Start HTTPD Service:**

   - Execute the following:
     ```bash
     if [ "$(systemctl is-active httpd)" = "inactive" ]; then
       systemctl enable --now httpd
     fi
     ```

3. **Configure Firewall:**

   - Run the following commands:
     ```bash
     firewall-cmd --permanent --add-service=http
     firewall-cmd --reload
     ```

4. **Create Directory if Not Exist:**

   - Check and create the directory if it doesn't exist:
     ```bash
     if [ -d "/var/www/html/sa" ]; then
       echo "/var/www/html/sa already exists"
     else
       mkdir /var/www/html/sa
     fi
     ```

5. **Allow Override:**

   - Add the following configuration to `/etc/httpd/conf.d/sa.conf`:
     ```bash
     echo "<Directory \"/var/www/html/sa\">" > /etc/httpd/conf.d/sa.conf
     echo "  AllowOverride all" >> /etc/httpd/conf.d/sa.conf
     echo "</Directory>" >> /etc/httpd/conf.d/sa.conf
     ```

6. **Add Authentication:**

   - Enter a username when prompted, and set up basic authentication:
     ```bash
     read -p "Enter User Name: " userName
     htpasswd -c /etc/myhttpdpassword ${userName}
     echo -e "AuthType Basic\nAuthName \"Private area\"\nAuthUserFile /etc/myhttpdpassword\nRequire valid-user" > /var/www/html/sa/.htaccess
     ```

7. **For Test Only:**

   - Create a simple HTML file for testing:
     ```bash
     echo "<h1>Hello ${userName}</h1>" > index.html
     cp index.html /var/www/html/sa/
     ```

8. **Restart HTTPD Service:**
   - Restart the Apache HTTP server:
     ```bash
     systemctl restart httpd
     ```

**Note:** Ensure that you have the necessary privileges to execute the script and make modifications to system configurations.
