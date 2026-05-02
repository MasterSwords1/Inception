NAME=inception

$(NAME): all

all:
	docker compose -f srcs/mandatory/docker-compose.yml up -d

build:
	docker compose -f srcs/mandatory/docker-compose.yml build

bonus:
	docker compose -f srcs/bonus/docker-compose.yml up -d

bonus_build:
	docker compose -f srcs/bonus/docker-compose.yml build

down:
	docker compose -f srcs/mandatory/docker-compose.yml down
	docker compose -f srcs/bonus/docker-compose.yml down

stats:
	docker compose -f srcs/mandatory/docker-compose.yml ps -a

bonus_stats:
	docker compose -f srcs/bonus/docker-compose.yml ps -a

log:
	docker compose -f srcs/mandatory/docker-compose.yml logs -n 10

bonus_log:
	docker compose -f srcs/bonus/docker-compose.yml logs -f
