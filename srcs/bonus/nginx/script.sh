#!/bin/bash

sleep 60

service nginx stop

nginx -g "daemon off;"
