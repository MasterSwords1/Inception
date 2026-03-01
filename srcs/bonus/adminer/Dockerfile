FROM alpine:3.22

RUN apk update && apk --no-cache add wget

RUN mkdir -p /var/www/wordpress/adminer

RUN wget https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php -O /var/www/wordpress/adminer/adminer.php

CMD ["busybox", "sh"]
