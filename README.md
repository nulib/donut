# DONUT

Donut is a Hydra head based on [Hyrax](http://github.com/projecthydra-labs/hyrax)

[![Build Status](https://travis-ci.org/nulib/donut.svg?branch=master)](https://travis-ci.org/nulib/donut)

## Dependencies

* [Redis](http://redis.io/)
    * Start Redis with `redis-server`
* [Local authentication configuration](https://github.com/nulib/donut/wiki/Authentication-setup-for-dev-environment)

## Initial Setup

* Clone the Donut GitHub repository
* Install dependencies: `bundle install`
* Setup the database: `rake db:migrate`
* Generate roles: `rake generate_roles`
* Create the default admin set: `rake hyrax:default_admin_set:create`
* Load the workflows in `config/workflows`: `rake hyrax:workflow:load`

## Running the Tests

Run the test suite:

   ```sh
   $ rake donut:ci
   ```

You may also want to run the Fedora and Solr servers in one window with:

   ```sh
   $ rake hydra:test_server
   ```

And run the test suite in another window:

   ```sh
   $ rake spec
   ```

## Adding an Admin user and assigning workflow roles

1. Run the development servers with `rake hydra:server` (or run Rails and Solr/Fedora separately with `rails s` and `rake server:development`).
1. Go to http://devbox.library.northwestern.edu/ and login with OpenAM
1. $ rake add_admin_role
1. Go to http://devbox.library.northwestern.edu/admin/workflow_roles and grant workflow roles if needed
