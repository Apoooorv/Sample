FROM centos:latest

RUN yum -y update \
    && yum -y install epel-release\
    && yum -y install --setopt=tsflags=nodocs \
       httpd mod_wsgi python-gunicorn python-pip

#Copying apache config file to apt folder
#COPY django.conf /etc/httpd/conf.d/

#Copying django application code in to /home/ directory
COPY sample /home/

#installing pip 
#RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
#RUN python get-pip.py

#RUN sed -i -e 's|^Listen 80$|Listen 8080|' \
           #-e 's|ErrorLog .*$|ErrorLog "/dev/stderr"|' \
           #-e 's|CustomLog .*$|CustomLog "/dev/stdout" combined|' \
#           -e '/^#ServerName/a ServerName localhost' \
#           -e '/^ServerRoot/a PidFile /var/tmp/httpd.pid' \
#    /etc/httpd/conf/httpd.conf

#installing django
RUN pip install django
RUN python /home/sample/manage.py migrate

RUN chmod a+rxw /home/
#RUN chmod a+rxw /run/httpd/
#RUN chmod -R a+rxw /etc/httpd/logs/
#RUN chmod -R a+rxw /var/logs/
#RUN apachectl -k start
#RUN chmod 777 /run/httpd/httpd.pid
#RUN chown apache:apache /run/httpd/httpd.pid
#RUN httpd -k restart
#RUN cd /home/
#RUN django-admin startproject sample

EXPOSE 8080

ENTRYPOINT gunicorn --bind 0.0.0.0:8080 --access-logfile=/home/sample.logs --pythonpath /home/sample/ sample.wsgi
#ENTRYPOINT ["httpd", "-D", "FOREGROUND"]
#ENTRYPOINT ["sleep","999999999"]
#ENTRYPOINT ["python /home/sample/manage.py runserver 8080"]
