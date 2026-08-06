NAME=inception
MANDATORY_DATA_DIRS=/home/$(USER)/data/mariadb_data /home/$(USER)/data/wp_data
BONUS_DATA_DIRS=/home/$(USER)/data/mariadb_data_bonus /home/$(USER)/data/wp_data_bonus /home/$(USER)/data/owncast_data

all: mandatory_dirs $(NAME)

mandatory_dirs:
	mkdir -p $(MANDATORY_DATA_DIRS)

$(NAME):
	docker compose -f srcs/mandatory/docker-compose.yml up -d

build: mandatory_dirs
	docker compose -f srcs/mandatory/docker-compose.yml build

bonus: bonus_dirs
	docker compose -f srcs/bonus/docker-compose.yml up -d

bonus_dirs:
	mkdir -p $(BONUS_DATA_DIRS)

bonus_build: bonus_dirs
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

.PHONY: all mandatory_dirs build bonus bonus_dirs bonus_build down re clean fclean stats bonus_stats log bonus_log
