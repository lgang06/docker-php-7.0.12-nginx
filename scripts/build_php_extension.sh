#/bin/sh
set -e
common ()
{
    ext=$1;
    if [ `cat /usr/local/php7/lib/php.ini | grep -i '^\[${ext}\]' | wc -l` = "0" ];then
        echo "[${ext}]" >> /usr/local/php7/lib/php.ini
        echo "extension = ${ext}.so" >>  /usr/local/php7/lib/php.ini
    fi;
}

ini_ext()
{
    name=$1
    val=$2
    if [ `cat /usr/local/php7/lib/php.ini | grep -i "^${name}" | wc -l` = "0" ];then
        echo "${name}=${val}" >> /usr/local/php7/lib/php.ini
    fi;
}
softPath=/usr/local/src

cd $softPath
yum -y install cyrus-sasl-devel
tar -zxvf libmemcached-1.0.18.tar.gz
cd libmemcached-1.0.18
./configure
make -j 2
make install
cd ..


# make memcached
cd $softPath/phpext
tar -zxvf memcached-3.0.3.tgz
cd memcached-3.0.3
/usr/local/php7/bin/phpize
./configure --with-php-config=/usr/local/php7/bin/php-config
make -j 2
make install
common memcached
cd ..
# memcached end

# make mongodb
tar -zxvf mongodb-1.2.9.tgz
cd mongodb-1.2.9
/usr/local/php7/bin/phpize
./configure --with-php-config=/usr/local/php7/bin/php-config
make -j 2
make install
common mongodb
cd ..
# mongodb end

# make zmq
## make libzmq
cd $softPath;
tar -zxvf zeromq-4.2.1.tar.gz
cd zeromq-4.2.1
./configure --prefix=/usr/local/zeromq
make -j 2
make install
## libzmq end
cd $softPath/phpext;
tar -zxvf zmq-1.1.3.tar.gz
cd zmq-1.1.3
/usr/local/php7/bin/phpize
./configure --with-php-config=/usr/local/php7/bin/php-config --with-zmq=/usr/local/zeromq
make -j 2
make install
common zmq
cd ..

# zmq end
# make yar
tar -zxvf msgpack-2.0.2.tgz
cd msgpack-2.0.2
/usr/local/php7/bin/phpize
./configure --with-php-config=/usr/local/php7/bin/php-config
make -j 2
make install
common msgpack
cd ..


tar -zxvf yar-2.0.2.tgz
cd yar-2.0.2
/usr/local/php7/bin/phpize
./configure --with-php-config=/usr/local/php7/bin/php-config --enable-msgpack
make -j 2
make install
common yar
cd ..
# yar end

# make yaf
tar -zxvf yaf-3.0.5.tgz
cd yaf-3.0.5
/usr/local/php7/bin/phpize
./configure --with-php-config=/usr/local/php7/bin/php-config 
make -j 2
make install
common yaf
ini_ext "yaf.use_namespace" "on"
ini_ext "yaf.library" "/usr/local/php7/lib/php/library"
cd ..
# yaf end



# make swoole 
tar -zxvf swoole-1.9.16.tgz;
cd  swoole-1.9.16;
/usr/local/php7/bin/phpize
./configure --with-php-config=/usr/local/php7/bin/php-config
make -j 2
make install
common swoole
if [ "`cat /usr/local/php7/lib/php.ini | grep 'swoole.use_namespace=on' | wc -l`" = "0" ];then
    echo "swoole.use_namespace=on" >>  /usr/local/php7/lib/php.ini
fi;
cd ..
# swoole end

# make redis
tar -zxvf redis-3.1.3.tgz
cd redis-3.1.3
/usr/local/php7/bin/phpize
./configure --with-php-config=/usr/local/php7/bin/php-config
make -j 2
make install
common redis
cd ..

yum clean all 
rm -rf /usr/local/src/*
