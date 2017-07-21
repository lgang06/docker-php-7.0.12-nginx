#/bin/sh
set -e
user=10jqka
group=10jqka
if [ "`cat /etc/passwd | grep -i ${user} | wc -l`" = "0" ];then
    useradd 10jqka
fi;
if [ "`cat /etc/group | grep -i ${group} | wc -l`" = "0" ];then
    groupadd 10jqka
fi;
#安装依赖包
yum -y install unzip \
  autoconf \
  automake \
  gcc \
  gcc-c++ \
  gcc-g77 \
  bison \
  libxml2 \
  libxml2-devel \
  openssl \
  openssl-devel \
  curl  \
  curl-devel \
  libjpeg-devel \
  libpng-devel \
  libcurl-devel \
  freetype-devel \
  pcre-devel  
cd /usr/local/src

#安装php7
## 安装re2c >= 0.13.4
tar -zxvf re2c-0.16.tar.gz
cd re2c-0.16
./autogen.sh
./configure && make && make install
cd ..
## re2c end

## 安装 libmcrypt
tar -zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure && make && make install
ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
cd ..
## libmcrypt end
echo "/usr/local/lib" >> /etc/ld.so.conf.d/local.conf
echo "/usr/local/lib64" >> /etc/ld.so.conf.d/local.conf
ldconfig

unzip -o php-7.0.12.zip
cd php-src-php-7.0.12
./buildconf --force
./configure  '--prefix=/usr/local/php7' '--with-config-file-path=/usr/local/php7/lib' '--enable-fpm' '--with-fpm-user=10jqka' '--with-fpm-group=10jqka' '--with-mysql=mysqlnd' '--with-mysqli=mysqlnd' '--with-pdo-mysql=mysqlnd' '--with-iconv-dir' '--with-freetype-dir=/usr/local/freetype' '--with-jpeg-dir' '--with-png-dir' '--with-zlib' '--with-libxml-dir=/usr' '--enable-xml' '--disable-rpath' '--enable-bcmath' '--enable-shmop' '--enable-sysvsem' '--enable-inline-optimization' '--with-curl' '--enable-mbregex' '--enable-mbstring' '--with-mcrypt' '--with-gd' '--enable-gd-native-ttf' '--with-openssl' '--with-mhash' '--enable-pcntl' '--enable-sockets' '--with-xmlrpc' '--enable-zip' '--enable-soap' '--with-gettext' '--disable-fileinfo' '--enable-opcache'
make && make install
cp php.ini-production /usr/local/php7/lib/php.ini
echo "include_path=.:/usr/local/php7/lib/php" >>  /usr/local/php7/lib/php.ini
echo "date.timezone = Asia/Shanghai" >>  /usr/local/php7/lib/php.ini
\cp -rf /build/conf/php/* /usr/local/php7/etc;
cd ..

# 安装nginx
tar -zxvf nginx-1.10.3.tar.gz 
cd nginx-1.10.3
./configure --prefix=/usr/local/nginx
make && make install
\cp /build/conf/nginx/nginx.conf /usr/local/nginx/conf;
cd ..
# nginx end

