A quick setup to get started contributing to diaspora\* with docker-compose.
This setup uses postgresql and will launch diaspora in development mode.

# Installation

- Clone the diapora repository: `git clone git@github.com:diaspora/diaspora.git`.
- Copy the Dockerfile and docker-compose.yml at the root of the repo.
- Have git ignore these files without touching diaspora’s .gitignore by adding them to .git/info/exclude:
```
Dockerfile
docker-compose.yml
```
- Edit config/database.yml with the following info for postgres:
```
port: 5432¬
host: postgres
username: diaspora¬
password: diaspora¬
```

If you wish to launch a sidekiq worker along with the rails server, uncomment the redis-related comments in docker-compose.yml and adds the following to your diaspora config:
```
...
single_process_mode: false
...
redis: 'redis://redis'
...
```
- Run `docker-compose build`.

- If everything went smoothly, prepare diaspora. The following will create the rails’ secret token, prepare the database, run the migrations and finally test the application.

```
$ docker-compose run --rm web /bin/bash -c 'rake generate:secret_token && \
                                            rake db:create && \
                                            rake db:migrate && \
                                            rake db:test:prepare && \
                                            rake assets:generate_error_pages && \
                                            rspec'
```


If the tests all pass (they should), you now have a functional diaspora pod.
Run the diaspora server with: `docker-compose up`.

Server is accessible at localhost:3000

# Accessing the rails console

- While your container is running: `docker-compose exec web rails console`
- For one-off commands: `docker-compose run --rm web rails console`

You can run rspec or pronto the same way.
