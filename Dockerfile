FROM centos:latest

RUN yum -y install httpd mod_wsgi python-psycopg2

#Copying apache config file to apt folder
COPY django.conf /etc/httpd/conf.d/

#Copying django application code in to /home/ directory
COPY sample /home/

#installing pip 
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
RUN python get-pip.py

#installing django
RUN pip install django
RUN python /home/sample/manage.py migrate

#RUN httpd -k restart
#RUN cd /home/
#RUN django-admin startproject sample

EXPOSE 8080

ENTRYPOINT ["httpd", "-D", "FOREGROUND"]
#ENTRYPOINT ["sleep","999999999"]
#ENTRYPOINT ["python /home/sample/manage.py runserver 8080"]
