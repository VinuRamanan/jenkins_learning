FROM python:3.7-buster
USER root
RUN apt-get update -qq \
    && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 gnupg-agent software-properties-common 
RUN apt-get install -y nginx gunicorn supervisor
EXPOSE 80
COPY . /app
WORKDIR /app
RUN mkdir -p /app/var/log
COPY ./requirements.txt /var/www/requirements.txt
RUN pip install -r /var/www/requirements.txt
COPY ./flask_app.supervisor /etc/supervisor/conf.d/flask_app.conf
RUN supervisord -c /etc/supervisor/supervisord.conf
RUN supervisorctl reread
RUN supervisorctl update
RUN supervisorctl avail 
RUN supervisorctl restart flask_app
COPY ./flask_app.nginx /etc/nginx/sites-available/flask_app
RUN ln -s /etc/nginx/sites-available/flask_app /etc/nginx/sites-enabled/flask_app
RUN nginx -t
CMD ["service", "nginx", "restart"]