FROM tutum/mysql:5.5
MAINTAINER Matt Burke "burkemw3@gmail.com"

RUN apt-get -y update

# install mysql, owncloud dependencies, and supervisor
RUN apt-get -y install apache2 bzip2 libapache2-mod-php5 php5-curl php5-gd php5-imagick php5-intl php5-json php5-mcrypt php5-mysql supervisor wget

# install owncloud
RUN wget -O - https://download.owncloud.org/community/owncloud-7.0.1.tar.bz2 | tar jx -C /var/www/

# configure supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# configure apache for owncloud
RUN chown -R www-data:www-data /var/www/owncloud
ADD ./000-default.conf /etc/apache2/sites-available/
RUN a2enmod rewrite

EXPOSE 80

VOLUME ["/var/www/owncloud/data", "/var/www/owncloud/config"]

CMD ["/usr/bin/supervisord"]
