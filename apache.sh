#! /bin/bash
# download apr/apr-util/httpd/pcre
wget https://mirrors.aliyun.com/apache/apr/apr-1.7.0.tar.gz
wget https://mirrors.aliyun.com/apache/apr/apr-util-1.6.1.tar.gz
wget https://mirrors.aliyun.com/apache/httpd/httpd-2.4.54.tar.gz
#pcre太慢就自己先下传上去
wget https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz
wget https://sourceforge.net/projects/pcre/files/pcre2/10.37/pcre2-10.37.tar.gz


# extra files
tar zxvf apr-1.7.0.tar.gz | tail
tar zxvf apr-util-1.6.1.tar.gz | tail
tar zxvf httpd-2.4.54.tar.gz | tail
tar zxvf pcre-8.45.tar.gz | tail
tar zxvf pcre2-10.37.tar.gz | tail


# install gcc g++ make
if dpkg -s gcc >/dev/null 2>&1;then
	echo "---------------gcc   installed---------------"
else
	apt install gcc -y
fi

if dpkg -s g++ >/dev/null 2>&1;then
	echo "---------------g++   installed---------------"
else
	apt install g++ -y
fi

if dpkg -s make >/dev/null 2>&1;then
	echo "---------------make   installed---------------"
else
	apt install make -y
fi

# install libxml2-dev libexpat-dev
if dpkg -s libxml2-dev >/dev/null 2>&1;then
	echo "---------------libxml2-dev installed----------"
else
	apt install libxml2-dev -y
fi
if dpkg -s libexpat-dev >/dev/null 2>&1;then
	echo "---------------libexpat installed-------------"
else 
	apt install libexpat-dev
fi

# install apr
cd apr-1.7.0
./configure --prefix=/usr/local/apr
make
make install
cd ../

# install apr-util
cd  apr-util-1.6.1
./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr
make
make install
cd ../

# install pcre
cd pcre-8.45
./configure --prefix=/usr/local/pcre --with-pcre=/usr/local/pcre
make
make install
cd ..

# install pcre2
cd pcre2-10.37
./configure --prefix=/usr/local/pcre2 --with-pcre2=/usr/local/pcre2
make
make install 
cd ..

# install httpd
cd httpd-2.4.54
./configure --prefix=/usr/local/apache2 --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --with-pcre=/usr/local/pcre --with-pcre2=/usr/local/pcre2
make
make install
cd ..


# clean
rm -rf httpd-2.4.54*
rm -rf apr-1.7.0*
rm -rf apr-util-1.6.1*
rm -rf pcre-8.45*

## startup apache
ldconfig
echo "-----------------------------------------"
echo "-----------httpd installed---------------"
echo "-----------------------------------------"
echo "-----------set ServerName----------------"
sed -i "s/#ServerName www.example.com:80/ServerName localhost/g" /usr/local/apache2/conf/httpd.conf
echo "-----------------------------------------"
echo "-----------set PATH----------------------"
sed -i "1a export PATH=\$PATH:/usr/local/apache2/bin" ~/.bashrc
source ~/.bashrc
echo "-----------------------------------------"
echo "-----------start httpd-------------------"
/usr/local/apache2/bin/apachectl -k start
echo "-----------------------------------------"
addr=$(ifconfig | grep 'inet addr' | sed 's/^.*addr://' | sed 's/ Bcast.*$//g' | head -n 1) 
echo "          $addr"
echo "-----------------------------------------"


