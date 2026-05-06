#!/bin/bash

sleep 30

service nginx stop

nginx -g "daemon off;"
