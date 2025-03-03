

# TESTING:


```
docker-compose exec web bundle exec rspec
```

# HOSTING

```
# Login to Heroku Container Registry
heroku container:login

# Build & push the updated Docker image
DOCKER_DEFAULT_PLATFORM=linux/amd64 heroku container:push web --app gft100p 

# Release the container
heroku container:release web --app gft100p

# Run migrations
heroku run rails db:migrate --app gft100p

rails runner "AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')"
docker-compose run --rm --entrypoint /bin/sh web -c "cd /refugeexperiences && bundle exec rails runner \"AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')\""
```

# RUN LOCALLY:

```
docker-compose down && docker-compose up --build
```

# API

Swagger page exists for 'experiences'

Additionally, for form purposes, Agencies and Zip Code lookups exist. 

Example:
`/zip_lookup?zip_code=20004`


# LINKS:
waybacktogovt.org
https://www.linkedin.com/in/waybacktogovt/


# Credits & License type

Origin: https://github.com/RefugeRestrooms/refugerestrooms

Copyleft; we need to post this repo as opensource, at the time it is finished.

