# OpenRegister Show The Mess

## Deployment

To setup a fresh heroku deployment:

```sh
heroku create --region eu \
       --buildpack "https://github.com/HashNuke/heroku-buildpack-elixir.git" \
       --org <org>

heroku apps:rename <your-app-name>

heroku addons:create heroku-postgresql:hobby-dev

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

# Create and migrate your database with:
mix ecto.create && mix ecto.migrate

# Install Node.js dependencies with:
npm install

# Optionally set database name ENV var, defaults to "show_the_mess_dev":
export DATABASE_NAME=show_the_mess_dev

# Start Phoenix endpoint with:
mix phoenix.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
