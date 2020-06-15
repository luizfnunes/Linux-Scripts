#!/bin/bash
# Web server installation script for manjaro linux.
# Requires SUDO installed
# Created by LuizFNunes

clear;
echo "Manjaro WebServer Script Install";
echo "Softwares to install:";
echo "  -apache";
echo "  -php";
echo "  -mariadb";
echo "  -phpmyadmin";
echo
echo "Sync the repositories:";
echo "#######################";
sudo pacman -Syu
echo
echo "Installing Apache Server";
echo "#######################";
sudo pacman -S --noconfirm apache
echo
echo "Apache successfully installed!";
echo "Do you want to activate Apache at system startup? (yes/no)";
read APACHEINIT;
echo
if [ "$APACHEINIT" == "yes" ];then
    sudo systemctl enable httpd
    echo "Apache enabled in system startup!";
else
    sudo systemctl disable httpd
    echo "Apache disabled in system startup!";
fi;
echo
echo "Instaling PHP";
echo "#######################";
sudo pacman -S --noconfirm php php-apache
PHPVERSION=$(php -v | head -n1 | cut -d" " -f2)
echo "PHP version $PHPVERSION installed. Restarting apache...";
sudo systemctl restart httpd
echo 
echo "Instaling MariaDB";
echo "#######################";
sudo pacman -S --noconfirm mariadb
echo "Installing databases";
echo "#######################";
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
echo "Starting MariaDB";
echo "#######################";
sudo systemctl start mysqld
echo "Do you want to activate MariaDB at system startup? (yes/no)";
read MARIADBINIT
if [ "$MARIADBINIT" == "yes" ];then
    sudo systemctl enable mysqld
    echo "MariaDB enabled in system startup!";
else
    sudo systemctl disable mysqld
    echo "MariaDB disabled in system startup!";
fi;
echo
echo "Executing secure instalation for MariaDB..."
echo "#######################";
sudo mysql_secure_installation
echo
echo "Installing phpMyAdmin"
echo "#######################";
sudo pacman -S --noconfirm phpmyadmin
echo
echo "All Ready! Press any key to exit...";
read EXIT
exit
