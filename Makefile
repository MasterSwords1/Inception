NAME=inception

all: $(NAME)

$(NAME):
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

re: fclean all

clean:
	docker compose -f srcs/mandatory/docker-compose.yml down --rmi all --remove-orphans
	docker compose -f srcs/bonus/docker-compose.yml down --rmi all --remove-orphans

fclean: clean
	docker system prune -a --volumes -f

stats:
	docker compose -f srcs/mandatory/docker-compose.yml ps -a

bonus_stats:
	docker compose -f srcs/bonus/docker-compose.yml ps -a

log:
	docker compose -f srcs/mandatory/docker-compose.yml logs -n 10

bonus_log:
	docker compose -f srcs/bonus/docker-compose.yml logs -n 10

.PHONY: all build bonus bonus_build down re clean fclean stats bonus_stats log bonus_log
