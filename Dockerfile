FROM amazonlinux:2

WORKDIR /tmp

# Update packages
RUN yum -y update
RUN yum -y install procps vim systemd yum-utils unzip wget sudo git jq

# Install httpd
RUN yum install -y httpd
RUN systemctl enable httpd
ADD ./docker/httpd.conf /etc/httpd/conf/httpd.conf
EXPOSE 80

# Set .bashrc
ADD ./docker/.bashrc /root/.bashrc

# Set ssh
RUN mkdir /root/.ssh
ADD ./docker/id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

# Install PHP
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php72
RUN sed -i -e "s/priority=10/priority=99/g" /etc/yum.repos.d/amzn2-core.repo
RUN yum install -y --enablerepo=remi,remi-php73 php php-devel php-mbstring php-pdo php-gd php-xml php-mcrypt php-z

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# node
RUN curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
RUN yum install -y --enablerepo=nodesource nodejs
RUN curl https://intoli.com/install-google-chrome.sh | bash
RUN npm install -g selenium-side-runner
RUN npm install -g chromedriver --unsafe-perm=true --allow-root

WORKDIR /var/www/html/scouter-github-vue
COPY ./docker/init_app.sh /root
RUN chmod +x /root/init_app.sh
COPY ./docker/scan_dir.php /root

# SSL
RUN yum install -y mod_ssl
RUN mkdir -p /etc/letsencrypt/live/itengineer-scouter.com
COPY ./docker/httpd-le-ssl.conf /etc/httpd/conf/
COPY ./docker/options-ssl-apache.conf /etc/letsencrypt/
COPY ./docker/ssl.conf /etc/httpd/conf.d

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
