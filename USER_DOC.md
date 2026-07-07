*This project has been created as part of the 42 curriculum by <ariyad>*

//# Understand what services are provided by the stack

To start the project, use `make build && make` to build the images and run docker compose up.

To stop the project, use `make down`.

To access wordpress, you simply type `https://localhost:8080` in your browser and `https://localhost:8080/wp-login.php` to enter the wordpress login page.

All credentials are stored in `.env` inside the project's source (ignored in .gitignore)

To check that services are running correctly, type `make stats` to see the condition of the containers.
