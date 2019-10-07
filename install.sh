#!/bin/bash

# ----------------------------------------------------------------------------------------------
# Echo with color
# @param $1 number
# @param $2 String
# E.g: cecho 1 'Text in blue'
# E.g: cecho 2 'text bolded and underline'
cecho() {
  case "$1" in
        #Blue
      1)
           echo -e "\e[34m$2\e[0m"
        ;;
        #Bold and underline
        2)
           echo -e "\e[1;4m$2 \e[0m"
        ;;
        #Green
        3)
           echo -e "\e[92m$2 \e[0m"
        ;;
        #Red
        4)
           echo -e "\e[31m$2 \e[0m"
        ;;
        #Bold
        3)
           echo -e "\e[1m$2 \e[0m"
        ;;
        * )
        echo $"Modo de Utilizacao:"
        exit 1

  esac
}

brew install bash

cecho 2 "#Instaling git  and creating document root                                                            "
    gitUsername=$1
    echo ""
    brew install git
    sudo mkdir -p /var/www/Graphite
    sudo chmod 777 -R /var/www

cecho 2 "#Cloning sh_web.git                                                                                   "
    git clone git@github.com:$gitUsername/sh_web.git /var/www/Graphite

cecho 2 "#Configuring workspace                                                                                "
    sudo mkdir -p /var/www/Graphite/assets
    sudo mkdir -p /var/www/Graphite/protected/runtime
    sudo chmod -R 777 /var/www/Graphite

cecho 2 "#Installing binaries - ImageMagic PHP PECL  HTTPD MYSQL MEMCACHED                                     "
    brew install php@7.1
    brew install httpd
    brew install imagemagick
    brew install mysql@5.7
    brew install memcached
    imagemagickPath=$(find /usr/local -iname ImageMagick 2>/dev/null -print | grep opt)
    echo "ImageMagic PATH: $imagemagickPath" 
    pecl=$(sudo find /usr/local -iname pecl 2>/dev/null -print | grep bin)
    alias pecl=$pecl
    pecl install imagick
    pecl install igbinary 
    pecl install imagick 
    brew install libmemcached
    brew install zlib
    pecl install memcache
    
    memcached xdebug

cecho 2 "#Configuring phppool, php.ini and pecl                                                                "
    sed -i -e 's/upload_max_filesize = 50M/upload_max_filesize = 2M/g' /usr/local/etc/php/7.1/php.ini
    sed -i -e 's/max_file_uploads = 10/max_file_uploads = 20M/g' /usr/local/etc/php/7.1/php.ini
    cp -frv conf/event.conf /usr/local/etc/php/7.1/php-fpm.d/
    cp -frv conf/ext_opcache.ini /usr/local/etc/php/7.1/conf.d
    cp -frv conf/ext_memcached.ini /usr/local/etc/php/7.1/conf.d
    cp -frv conf/httpd.conf /usr/local/etc/httpd/httpd.conf
    cp -frv conf/graphite.conf /usr/local/etc/httpd

cecho 2 "#Starting Services                                                                                    "
    brew services start php@7.1
    brew services start mysql@5.7
    brew services start memcached
    brew services start httpd

cecho 2 "#Configuring Mysql                                                                                     "
    /usr/local/opt/mysql@5.7/bin/./mysql -u root < database.sql

cecho 2 "#Installing dependencies with composer                                                                 "
    curl -o /var/www/protected/libraries/composer.phar https://getcomposer.org/download/1.9.0/composer.phar 
    cd /var/www/protected/libraries/
    chmod +x composer.phar
    composer.phar install

cecho 2 "#Configuring app-config-file                                                                           "
    sudo cp /var/www/protected/config/graphite.example.yaml /etc/graphite.yaml
