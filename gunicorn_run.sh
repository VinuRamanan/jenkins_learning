#!/bin/bash


supervisord -c /etc/supervisor/supervisord.conf
supervisorctl reread
supervisorctl update
supervisorctl avail
supervisorctl restart flask_app

nginx -t