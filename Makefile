all: start

clean:
	sudo docker compose --project-directory srcs down --rmi all -v --remove-orphans

fclean: clean
	@sudo hostsed rm 127.0.0.1 eharuni.42.fr && echo "successfully removed eharuni.42.fr to /etc/hosts"
	sudo rm -rf /home/eharuni/data/*
	sudo docker system prune --volumes --all --force
	sudo docker network prune --force
	sudo docker volume prune --force

re: fclean all

start:
	@sudo hostsed add 127.0.0.1 eharuni.42.fr && echo "successfully added eharuni.42.fr to /etc/hosts"
	sudo mkdir -p /home/eharuni/data/mariadb /home/eharuni/data/wordpress
	sudo docker-compose --project-directory srcs up -d --build

stop:
	sudo docker-compose --project-directory srcs stop

restart:
	sudo docker-compose --project-directory srcs restart

down:
	sudo docker-compose --project-directory srcs down

ps:
	sudo docker-compose --project-directory srcs ps

logs:
	sudo docker-compose --project-directory srcs logs -f

.PHONY: all clean fclean re start stop down restart ps logs
