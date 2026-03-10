NAME=inception

$(NAME): all


all:
	docker compose -f srcs/bonus/docker-compose.yml up -d

bonus:
	docker compose -f srcs/mandatory/docker-compose.yml up -d
