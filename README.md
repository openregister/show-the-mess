# OpenRegister Show The Mess

## Data repository configuration

To add a data comparison page for lists in a data repository, there are two
steps.

### Add maps/index.yml

Add a `maps/index.yml` file to the data repository to configure which lists to
include in the data comparison page. You define labels and primary key fields
here as well.

For example if you have a `prison-data` repository with the following maps
files:

```
maps/contracted-out.tsv
maps/nomis-code.tsv
```

Create a `maps/index.yml` file with an entry for each map file. Add a first
entry for the register data. For example:

```yaml
---
prison:
  description: Prison in prison register
  key: prison
nomis-code:
  description: NOMIS code and name (includes former prisons)
  key: nomis
contracted-out:
  description: Prison name in NOMS spend data over £25,000 files
  key: contracted-out
```

You use the name of register or TSV file as the root level key in the
`maps/index.yml`, e.g. `prison`, `nomis-code`, `contracted-out`.

Set `description` with the label to show for the data on the data comparison
page.

Set `key` as the field name from the TSV file that is the primary key for
that register or data list, e.g. `prison`, `nomis`, `contracted-out`.

### Add link from application homepage:

Open the
[./web/templates/page/contents_list.html.eex](https://github.com/openregister/show-the-mess/blob/master/web/templates/page/contents_list.html.eex)
template and add a link for the new data repository.

You'll need to define the following parameters in the link href:

```
register=[name of register]
data=[path to register data file]
maps=[path to maps directory]
```

For example:
```
register=prison
data=prison-data/master/data/discovery/prison/prisons.tsv
maps=prison-data/master/maps
```

So, in the `./web/templates/page/contents_list.html.eex` template the link
markup is:

```
<li><a href="/?register=prison&data=prison-data/master/data/discovery/prison/prisons.tsv&maps=prison-data/master/maps">Prison</a></li>
```

## Clearing the cache

The application caches data retrieved from data repositories.

To clear the cache, visit the following link `/clear`:

```
https://[host]/clear
```

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

## Local development

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
