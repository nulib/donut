# DONUT

Donut is a Hydra head based on [Hyrax](http://github.com/projecthydra-labs/hyrax)

[![Build Status](https://travis-ci.org/nulib/donut.svg?branch=master)](https://travis-ci.org/nulib/donut)

## Dependencies

* [Redis](http://redis.io/)
  * Start Redis with `redis-server`
* [Local authentication configuration](https://github.com/nulib/donut/wiki/Authentication-setup-for-dev-environment)
* [Geonames user registration](http://www.geonames.org/manageaccount)
  * For local development, add the registered user to `settings.local.yml` with the `geonames_username` key, e.g. `geonames_username: geonames_test_user`
* Add local fits path to `/config/settings.local.yml`

  ```
  fits:
    path: /usr/local/bin/fits
  ```

## Initial Setup

* Clone the Donut GitHub repository
* Install dependencies: `bundle install`
* Setup the database: `rake db:migrate`
* Generate roles: `rake generate_roles`
* Run `rake docker:dev:up` in a separate tab to start solr, fedora, cantaloupe, and localstack
* Run `rake donut:seed ADMIN_USER=[your NetID] ADMIN_EMAIL=[your email]` to initialize the stack

## Running the Tests

Run the test suite:

```sh
$ rake donut:ci
```

You can run rubocop and the specs independently with:

```sh
$ rake donut:ci:rubocop
$ rake donut:ci:rspec
```

You may also want to run the Fedora and Solr servers in one window with:

```sh
$ rake docker:test:up
```

And run the test suite in another window:

```sh
$ rake spec
```

### Running the tests for our new CSV importer work from hyrax

the active elastic job gem requires an environment variable to be set otherwise all the specs fail. so run this first:

```sh
$ export PROCESS_ACTIVE_ELASTIC_JOBS=true
```

## Notes on the Docker stack

* You can replace `up` with `daemon` in `docker:dev:up` and `docker:test:up` to run the Docker services in the background
  instead of in a separate tab. To stop the stack, use (for example) `rake docker:dev:down`.
* The test stack always cleans up its data when it comes down. To clean the dev stack, use `rake docker:dev:clean`.

## Adding an Admin user and assigning workflow roles

1. Run the development servers with `rake docker:dev:up` (or `daemon`) and `rails s`
1. Go to http://devbox.library.northwestern.edu/ and login with OpenAM
1. To make the last user who logged in (you) and admin, run `rake donut:add_admin_role`
1. Go to http://devbox.library.northwestern.edu/admin/workflow_roles and grant workflow roles if needed
