#!/bin/bash

sleep 10

service nginx stop

nginx -g "daemon off;"
