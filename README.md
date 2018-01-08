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
* Run `fcrepo_wrapper` and `solr_wrapper` in separate tabs to start solr and fedora
* Create the default admin set: `rake hyrax:default_admin_set:create`
* Load the workflows in `config/workflows`: `rake hyrax:workflow:load`

## Minio

To pull minio and stand it up, assuming you have docker installed:

* `docker pull minio/minio`
* `docker run -p 9000:9000 -e "MINIO_ACCESS_KEY=travis-build-key" -e "MINIO_SECRET_KEY=travis-build-secret" minio/minio server ./data`

### Create and populate bucket in minio

Run `bundle exec rake s3:setup`, which creates a new bucket and populates it with our fixtures. If you already have the bucket, then run `bundle exec rake s3:populate_bucket` to upload the fixture data to the bucket.

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
$ rake hydra:test_server
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

## Adding an Admin user and assigning workflow roles

1. Run the development servers with `rake hydra:server` (or run Rails and Solr/Fedora separately with `rails s` and `rake server:development`).
1. Go to http://devbox.library.northwestern.edu/ and login with OpenAM
1. To make the last user who logged in (you) and admin, run `rake add_admin_role`
1. Go to http://devbox.library.northwestern.edu/admin/workflow_roles and grant workflow roles if needed
