NAME=inception

$(NAME): all

all:
	docker compose -f srcs/mandatory/docker-compose.yml build
	docker compose -f srcs/mandatory/docker-compose.yml up -d

bonus:
	docker compose -f srcs/bonus/docker-compose.yml build
	docker compose -f srcs/bonus/docker-compose.yml up -d
	docker container exec wordpress wget https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php -O /var/www/wordpress/adminer.php

bonus_down:
	docker compose -f srcs/mandatory/docker-compose.yml down

bonus_stats:
	docker compose -f srcs/mandatory/docker-compose.yml ps -a

log:
	docker compose -f srcs/mandatory/docker-compose.yml logs -n 10

bonus_log:
	docker compose -f srcs/bonus/docker-compose.yml logs -n 10
