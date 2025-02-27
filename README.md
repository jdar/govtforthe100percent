https://github.com/RefugeRestrooms/refugerestrooms

Copyleft; we need to post this repo as opensource, at the time it is finished.



TESTING:


```
docker-compose exec web bundle exec rspec
```

HOSTING
```
# Login to Heroku Container Registry
heroku container:login

# Build & push the updated Docker image
DOCKER_DEFAULT_PLATFORM=linux/amd64 heroku container:push web --app gft100p 

# Release the container
heroku container:release web --app gft100p

# Run migrations
heroku run rails db:migrate --app gft100p
```

RUN LOCALLY:



