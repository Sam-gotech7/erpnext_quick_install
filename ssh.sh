#!/bin/bash

# Color definitions for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Define necessary variables for HRMS installation and SSL setup
bench_version="version-15"  # Set the bench version, e.g., "version-13", "version-14", or "version-15"
site_name="poc.redtra.com"    # Set the site name to the domain you are configuring
USER=$(whoami)             # Automatically get the current system user
email_address=""           # Initialize to empty, will be filled by user input

# Prompt user for HRMS installation decision
echo -e "${LIGHT_BLUE}Would you like to install HRMS? (yes/no)${NC}"
read -p "Response: " hrms_install
hrms_install=$(echo "$hrms_install" | tr '[:upper:]' '[:lower:]')

# Install HRMS if chosen
case "$hrms_install" in
    "yes" | "y")
        echo -e "${YELLOW}Installing HRMS app...${NC}"
        bench get-app hrms --branch $bench_version
        bench --site $site_name install-app hrms
        echo -e "${GREEN}HRMS app installed successfully.${NC}"
        ;;
    *)
        echo -e "${YELLOW}Skipping HRMS installation.${NC}"
        ;;
esac

# Prompt user for SSL installation decision
echo -e "${YELLOW}Would you like to install SSL? (yes/no)${NC}"
read -p "Response: " continue_ssl
continue_ssl=$(echo "$continue_ssl" | tr '[:upper:]' '[:lower:]')

# Install SSL if chosen
case "$continue_ssl" in
    "yes" | "y")
        echo -e "${YELLOW}Please ensure your domain name is pointed to this IP and is accessible.${NC}"
        echo -e "${YELLOW}Enter your email address for SSL certificate registration:${NC}"
        read -p "Email Address: " email_address
        echo -e "${YELLOW}Installing Certbot for SSL certificate installation...${NC}"
        sudo apt install snapd -y
        sudo snap install core
        sudo snap refresh core
        sudo snap install --classic certbot
        sudo ln -s /snap/bin/certbot /usr/bin/certbot
        sudo certbot --nginx --non-interactive --agree-tos --email "$email_address" -d "$site_name"
        echo -e "${GREEN}SSL certificate installed successfully.${NC}"
        ;;
    *)
        echo -e "${RED}Skipping SSL installation.${NC}"
        ;;
esac
