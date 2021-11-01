# DONUT (Archived)

- **Note**: the Donut project is no longer in use. Please visit [Meadow](https://github.com/nulib/meadow) to see our current repository. 

Donut is a Hydra head based on [Hyrax](http://github.com/projecthydra-labs/hyrax)

[![Build Status](https://travis-ci.org/nulib/donut.svg?branch=master)](https://travis-ci.org/nulib/donut)

## Dependencies

- Ruby >= 2.6
  - you can use [`rbenv`](https://github.com/rbenv/rbenv) or [`rvm`](https://rvm.io/) to install Ruby
- Follow the [Dev Environment Setup](http://docs.rdc.library.northwestern.edu/2._Developer_Guides/Environment_and_Tools/Developer-Tools---Dev-Environment-Setup/#setup) instructions
- Docker (we're using docker for mac: https://www.docker.com/docker-mac)
- Install [`devstack`](https://github.com/nulib/devstack) according to the instructions in the README
- [Geonames user registration](http://www.geonames.org/manageaccount)
  - The `geonames_username` key is defined in our shared configuration file.
- Fits > 1.0.5 `brew install fits`
- Vips `brew install vips`

## Initial Setup

- Clone the Donut GitHub repository
- Install Bundler (version that's in the [`Gemfile.lock`](https://github.com/nulib/donut/blob/master/Gemfile.lock#L1663)) if it's not installed already `gem install bundler -v "~>2.0.1"`]
- Install dependencies: `bundle install`
- Run `devstack up donut` in a separate tab to start dependency services

- Run `rake donut:seed` to initialize the stack.

  - Optional arguments to `donut:seed` (may be used in combination):
    - `bundle exec rake donut:seed ADMIN_USER=[your NetID] ADMIN_EMAIL=[your email]` to automatically add yourself an admin user
    - `bundle exec rake donut:seed ADMIN_USER=[your NetID] ADMIN_EMAIL=[your email] SEED_FILE=[path to YAML file]` to automatically add users and admin_sets. There is a sample seed file in `spec/fixtures/files/test_seed.yml`

- Create a fake AWS profile:

```sh
$ aws --profile fake configure
# enter dummy values for "AWS Access Key ID" and "AWS Secret Access Key".
# Set the "Default region name" to "us-east-1", use default[None] for format

# add this to your .zshrc, .bashrc, etc.
export AWS_PROFILE=fake
```

## Running the App

```
bundle exec rails s
```

Donut should be live at: https://devbox.library.northwestern.edu:3000/

## Stopping the application

You can stop the Phoneix server with `Ctrl + C`

You can stop devstack by running `devstack down`. You local data (from the database, ldap, etc) will persist after devstack shuts down.

If you need to clear your data and reset the entire development environment, run `devstack down -v`

After initial setup, you don't need to run `rake donut:seed...` again unless you've run `devstack down -v`.

Read more about [Devstack](https://github.com/nulib/devstack) commands here.

### Set up an "NUL Collection" Collection Type

Donut only wants "NUL Collection" types to be public. In order to make these available to the front-end React app:

1. Go to `Dashboard > Settings > Collection Type` and add a "NUL Collection" collection type.
2. In `config/settings/development.local.yml`, add the gid of the "NUL Collection" collection type (or one you want to index in Elasticsearch). Ex: `nul_collection_type: gid://nextgen/hyrax-collectiontype/3`.
3. Re-start the Rails server

**Note**: Only Donut collections of the collection type "NUL Collection" will appear in the front-end application.

More detailed information on Collection/Indexing setup here: [Collection Type Indexing](https://github.com/nulib/repodev_planning_and_docs/wiki/Collection-Type---Indexing)

## Running the Tests

Bring up the test stack in one window with:

```sh
$ devstack -t up donut
```

Run the SEED task for the test environment:

```sh
$ rake donut:seed RAILS_ENV=test
```

Run the test suite in another window:

```sh
$ rake spec
```

Or, you can run the test suite:

```sh
$ rake donut:ci
```

You can alternatively run rubocop and the specs independently with:

```sh
$ rake donut:ci:rubocop
$ rake donut:ci:rspec
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

- Run the `rake donut:seed` or `rake s3:setup` rake task to create and populate the S3 bucket
- Run the importer from the application root directory with the command:

```sh
$ bin/import_from_s3 dev-batch sample.csv
```

### Seed Data

- Run the batch importer with the `seed-data.csv` file to load 30 sample records (this will take some time)
- Make sure you have first run `bundle exec rake s3:setup` to populate the s3 bucket
- Then run:

```sh
$ bin/import_from_s3 dev-batch seed-data.csv
```

### Running the tests for our new CSV importer work from hyrax

the active elastic job gem requires an environment variable to be set otherwise all the specs fail. so run this first:

```sh
$ export PROCESS_ACTIVE_ELASTIC_JOBS=true
```

## Notes on the Docker stack

- You can replace `up` with `daemon` in `docker:dev:up` and `docker:test:up` to run the Docker services in the background
  instead of in a separate tab. To stop the stack, use (for example) `rake docker:dev:down`.
- The test stack always cleans up its data when it comes down. To clean the dev stack, use `rake docker:dev:clean`.

## Adding an Admin user and assigning workflow roles

1.  Run the development servers with `rake docker:dev:up` (or `daemon`) and `rails s`
2.  Go to https://devbox.library.northwestern.edu:3000/ and login
3.  To make the user who logged in an admin, run `rake donut:add_admin_role ADMIN_USER[your NetID]`
4.  Go to https://devbox.library.northwestern.edu:3000/admin/workflow_roles and grant workflow roles if needed
