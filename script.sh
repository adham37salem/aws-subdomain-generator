#!/bin/bash

# Inputs to be entered & Key Defination
read -p "Enter domain name: " DOMAIN
read -p "Enter subdomain name: " subfolder
read -p "Enter Hosted Zone ID: " HOSTED_ZONE_ID
read -p "Enter Elastic Load Balance Zone ID: " ELB_ZONE_ID
read -p "Enter Elastic Load Balance DNS ID: " ELB_DNS

echo $DOMAIN

# Create the subfolder
sudo mkdir -p /var/www/html/$subfolder
sudo chown -R www-data:www-data /var/www/html/$subfolder
sudo chmod -R 755 /var/www/html/$subfolder

# Create Apache Virtual Host Configuration
CONFIG_FILE="/etc/apache2/sites-available/$subfolder.$DOMAIN.conf"

sudo bash -c "cat > $CONFIG_FILE" <<EOF
<VirtualHost *:80>
    ServerName $subfolder.$DOMAIN
    DocumentRoot /var/www/html/$subfolder

    <Directory /var/www/html/$subfolder>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/$subfolder_error.log
    CustomLog \${APACHE_LOG_DIR}/$subfolder_access.log combined
</VirtualHost>
EOF

# Enable the site and reload Apache
sudo a2ensite $subfolder.$DOMAIN.conf
sudo systemctl reload apache2

# Create Route 53 DNS Record
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch '{
  "Changes": [{
    "Action": "CREATE",
    "ResourceRecordSet": {
      "Name": "'$subfolder'.'$DOMAIN'",
      "Type": "A",
      "AliasTarget": {
        "HostedZoneId": "'$ELB_ZONE_ID'",
        "DNSName": "'$ELB_DNS'",
        "EvaluateTargetHealth": false
      }
    }
  }]
}'

# Displaying Success message
echo "Subdomain $subfolder.$DOMAIN has been created and linked to the load balancer."
