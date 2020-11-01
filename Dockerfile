FROM python:3.7-buster
USER root
RUN apt-get update -qq \
    && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 gnupg-agent software-properties-common 
RUN apt-get install -y nginx gunicorn supervisor bash net-tools vim
EXPOSE 80
COPY . /flask_app
WORKDIR /flask_app
RUN mkdir -p /flask_app/var/log
RUN chmod +x run.sh
RUN chmod +x gunicorn_run.sh
COPY ./requirements.txt /var/www/requirements.txt
RUN pip install -r /var/www/requirements.txt
COPY ./flask_app.supervisor /etc/supervisor/conf.d/flask_app.conf
RUN supervisord -c /etc/supervisor/supervisord.conf
CMD ["service", "supervisor", "start"] 
COPY ./flask_app.nginx /etc/nginx/sites-available/flask_app
RUN ln -s /etc/nginx/sites-available/flask_app /etc/nginx/sites-enabled/flask_app
RUN nginx -t
CMD ["service", "nginx", "stop"]
RUN ./gunicorn_run.sh
RUN nginx -t
CMD ["service", "nginx", "start"]
CMD ["nginx", "-g", "daemon off;"]