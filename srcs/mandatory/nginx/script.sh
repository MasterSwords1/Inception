#!/bin/bash

sleep 15

service nginx stop

nginx -g "daemon off;"
