# OpenRegister Show The Mess

## Deployment

To setup a fresh heroku deployment:

```sh
heroku create --region eu \
       --buildpack "https://github.com/HashNuke/heroku-buildpack-elixir.git" \
       --org <org>

heroku buildpacks:add https://github.com/gjaldon/heroku-buildpack-phoenix-static

heroku apps:rename <your-app-name>

heroku config:set HOST=<host domain e.g. example.herokuapp.com> \
                  POOL_SIZE=18 \
                  SECRET_KEY_BASE="`mix phoenix.gen.secret`"

git push heroku master
# or
git push heroku yourbranch:master

heroku open
```

## Local Development

Install Elixir, if not already installed:

```sh
brew update
brew install elixir
```

To start the Phoenix app locally:

```sh
# Install dependencies with:
mix deps.get

# Install Node.js dependencies with:
npm install

# Start Phoenix endpoint with:
mix phoenix.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
