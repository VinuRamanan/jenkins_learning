FROM python:3.7-buster
USER root
RUN apt-get update -qq \
    && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 gnupg-agent software-properties-common 
RUN apt-get install -y nginx gunicorn supervisor bash net-tools vim
COPY . /flask_app
WORKDIR /flask_app
RUN mkdir -p /flask_app/var/log
chmod +x run.sh
COPY ./requirements.txt /var/www/requirements.txt
RUN pip install -r /var/www/requirements.txt
COPY ./flask_app.supervisor /etc/supervisor/conf.d/flask_app.conf
RUN supervisord -c /etc/supervisor/supervisord.conf
CMD ["service", "supervisor", "start"] 
RUN supervisorctl restart flask_app
EXPOSE 80
COPY ./flask_app.nginx /etc/nginx/sites-available/flask_app
RUN ln -s /etc/nginx/sites-available/flask_app /etc/nginx/sites-enabled/flask_app
RUN nginx -t
CMD ["service", "nginx", "restart"]
CMD ["nginx", "-g", "daemon off;"]