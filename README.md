# DONUT

Donut is a Hydra head based on [Hyrax](http://github.com/projecthydra-labs/hyrax)

[![Build Status](https://travis-ci.org/nulib/donut.svg?branch=master)](https://travis-ci.org/nulib/donut)

## Dependencies

* [Local authentication configuration](https://github.com/nulib/donut/wiki/Authentication-setup-for-dev-environment)
* Docker (we're using docker for mac: https://www.docker.com/docker-mac)
* [Geonames user registration](http://www.geonames.org/manageaccount)
  * For local development, add the registered user to `settings.local.yml` with the `geonames_username` key, e.g. `geonames_username: geonames_test_user`
* Add local fits path to `/config/settings/local.yml`

  ```
  fits:
    path: /usr/local/bin/fits
  ```

## Initial Setup

* Clone the Donut GitHub repository
* Install dependencies: `bundle install`
* Run `rake docker:dev:up` in a separate tab to start solr, fedora, cantaloupe, and localstack
* Setup the database: `rake db:setup`
* Generate roles: `rake generate_roles`

* Run `rake donut:seed` to initialize the stack.
  * Optional arguments to `donut:seed` (may be used in combination):
    * `ADMIN_USER=[your NetID] ADMIN_EMAIL=[your email]` to automatically add an admin user
    * `SEED_FILE=[path to YAML file]` to automatically add users and admin_sets. There is a sample seed file in `spec/fixtures/files/test_seed.yml`

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

You'll need to run the SEED task for the test environment as well:

```sh
$ rake donut:seed RAILS_ENV=test
```

And run the test suite in another window:

```sh
$ rake spec
```

#### Run the JavaScript tests

Run Jasmine server:

```sh
$ rake jasmine
```

Run all tests:

```sh
$ http://localhost:8888
```

Run the javascript test suite:

```sh
$ rake jasmine:ci
```

### Running the Batch importer from the command line
* Run the `rake donut:seed` or `rake s3:setup` rake task to create and populate the S3 bucket
* Run the importer from the application root directory with the command:

```sh
$ bin/import_from_s3 dev-batch sample.csv
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

1.  Run the development servers with `rake docker:dev:up` (or `daemon`) and `rails s`
1.  Go to http://devbox.library.northwestern.edu/ and login with OpenAM
1.  To make the user who logged in an admin, run `rake donut:add_admin_role ADMIN_USER[your NetID]`
1.  Go to http://devbox.library.northwestern.edu/admin/workflow_roles and grant workflow roles if needed
