#!/bin/bash

set -x

cd $HOME
sudo cp $HOME/Desktop/ruqqus/nginx.txt /etc/nginx/sites-available/ruqqus.com.conf
sudo nginx -s reload
. $HOME/Desktop/ruqqus/venv/bin/activate
. $HOME/Desktop/ruqqus/env.sh
cd $HOME/Desktop/ruqqus
pip3 install -r requirements.txt
export PYTHONPATH=$PYTHONPATH:$HOME/Desktop/ruqqus
cd $HOME

#echo "starting background worker"
#python ruqqus/scripts/recomputes.py

#echo "starting chat worker"
#gunicorn ruqqus.__main__:app load_chat -k eventlet  -w 1 --worker-connections 1000 --max-requests 1000000 --preload --bind 127.0.0.1:5001 -D

echo "starting regular workers"
gunicorn ruqqus.__main__:app -k gevent -w $WEB_CONCURRENCY --worker-connections $WORKER_CONNECTIONS --preload --max-requests 10000 --max-requests-jitter 500 --bind 127.0.0.1:5000
