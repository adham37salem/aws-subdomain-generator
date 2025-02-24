<img src="https://i.ibb.co/VpS9jvXm/Amazon-Web-Services-AWS-Logo.png" alt="Untitled-1-01">


# AWS Subdomain Generator 

## Overview
This Bash script automates the process of creating and configuring a subdomain on an Apache web server. It also integrates with AWS Route 53 to create a DNS record, linking the subdomain to an Elastic Load Balancer (ELB). This ensures a seamless and efficient way to deploy new subdomains without manual configuration.

## Importance of This Script
1. **Automation**: Saves time by automating tedious tasks such as creating directories, setting permissions, configuring Apache, and setting up DNS records.
2. **Consistency**: Ensures that all subdomains are set up with the same configuration, reducing human errors.
3. **Integration**: Connects your subdomain to AWS Route 53 and Elastic Load Balancer, enhancing scalability and reliability.
4. **Security**: Proper permission management ensures that the subdomain has controlled access.

## Prerequisites
Before running this script, ensure that:
- You have Apache installed and running (`sudo apt install apache2 -y`).
- AWS CLI is installed and configured with the necessary permissions.
- You have an existing Hosted Zone in AWS Route 53.
- An Elastic Load Balancer is set up with a valid DNS name and Zone ID.

## How to Use the Script
1. Save the script as `create_subdomain.sh` and grant it executable permission:
   ```bash
   chmod +x create_subdomain.sh
   ```
2. Run the script and enter the required information when prompted:
   ```bash
   ./create_subdomain.sh
   ```
3. The script will:
    - Create a directory for the subdomain.
    - Configure Apache to serve the subdomain.
    - Restart Apache to apply changes.
    - Create an AWS Route 53 DNS record pointing to the Elastic Load Balancer.
4. Once completed, you can access your subdomain at `http://<subdomain>.<domain>`.

## Troubleshooting
- If Apache does not restart, check the error logs:
  ```bash
  sudo journalctl -xe
  ```
- If the subdomain does not resolve, verify your Route 53 records using:
  ```bash
  aws route53 list-resource-record-sets --hosted-zone-id <HOSTED_ZONE_ID>
  ```

## Conclusion
This script streamlines the process of deploying new subdomains while ensuring integration with AWS infrastructure. It is a valuable tool for system administrators and DevOps teams managing multiple subdomains efficiently.

