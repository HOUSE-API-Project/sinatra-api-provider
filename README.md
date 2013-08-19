# Sinatra API Provider

## This codes provide API service for MongoDB

The simple web API interface of MongoDB.

    Get parameters.

    limit                  # The count of json length, default as one. Zero means unlimited.
    from                   # The format is YYYYMMDDhhmmss.
    to                     # from and to require a combination.
    period                 # day or week or month. It can't be compatible with period and from/to.
    sort                   # sort=asc means sort by ascending. It will sort decending order in other cases.

## How do I get started?

    bundle install --path=vendor/bundler

## How do I start the application?

Start the app by running:

    bundle exec rake s

