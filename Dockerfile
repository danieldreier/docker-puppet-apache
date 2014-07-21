FROM danieldreier/wheezy-puppet-agent
MAINTAINER Daniel Dreier <ddreier@thinkplango.com>

EXPOSE 80
RUN mkdir -p /var/www/example.com
#RUN echo "<?php phpinfo(); ?>" > /var/www/example.com/www/index.php
ADD www /var/www/example.com/www
RUN chown -R www-data:www-data /var/www/example.com/www
ADD Puppetfile /etc/puppet/Puppetfile
RUN mkdir /etc/puppet/local
ADD site /etc/puppet/local/site
ADD hieradata /etc/puppet/hieradata
RUN apt-get update && puppet apply /etc/puppet/local/site/manifests/roles/base/r10k/install.pp
RUN apt-get update && puppet apply -e "class { 'site::roles::base::hiera::install': }"
RUN apt-get update && puppet apply /etc/puppet/manifests/site.pp


#ENTRYPOINT ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
#ENTRYPOINT /usr/sbin/apachectl -D FOREGROUND
#CMD ["-D", "FOREGROUND"]
#CMD []
