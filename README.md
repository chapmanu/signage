# Digital Signage 2.0

![Codeship](https://codeship.com/projects/d35abc40-275e-0133-fc89-7af7072ae828/status?branch=master)

This application manages digital signage across the Chapman University campus. Sign owners can build and manage signs through the admin interface. Screens on campus display signs by opening a browser pointed at the appropriate `SignsController#play` endpoint.

The monitors and virtual machines powering them are administered by IS&T.

### Installation
Signage requires PostgreSQL as its datastore. See [Brew install guide here](http://exponential.io/blog/2015/02/21/install-postgresql-on-mac-os-x-via-brew/).

You'll also need to install ImageMagick. Mac instructions can be found [here](http://stackoverflow.com/questions/29377651/rails-error-imagemagick-graphicsmagick-is-not-installed).

```
git clone https://github.com/chapmanu/signage.git
cd signage
bundle install

# This file is needed for tests (and dev?). Ask a team member for the environment variables.
touch .env

# Clone production data
cap production db:clone
```

### Development
#### Tests

All tests:

    bundle exec rake test

Single test:

    bundle exec rake test test/models/sign_test.rb

#### Local Server

To start the the local server on port 3000:

    bundle exec rails server -b 0.0.0.0 -p 3000

Then head over to [localhost:3000](http://localhost:3000).

#### Mock Feed

There is a mock campus alerts XML feed that has been added within the application. It currently offers two mock feeds, one without alerts and one with an alert:

- http://localhost:3000/mock/campus_alerts_feed/
- http://localhost:3000/mock/campus_alerts_feed/emergency

A shim has been introduced to signs that allows you -- in staging only -- to instruct a sign to use one of these feeds by setting an `alerts-feed` parameter in the query string. For example:

- https://dev-signage.chapman.edu/signs/test-sign/play?alerts-feed=https://dev-signage.chapman.edu/mock/campus_alerts_feed/emergency

For more details, see the `Sign` model `campus_alert_feed=` method.


### Deployment

Deployment is handled as expected by capistrano. To deploy a feature branch to staging:

    cap staging deploy BRANCH=my-feature-branch

See team lead for server authentication information.

- Production Server: signage.chapman.edu
- Staging Server: dev-signage.chapman.edu

