# AC Forecast

It get's the weather based on an address or a zipcode.

## Environment note

I intentionally committed the `GEOCODE_API_TOKEN` for this project so it is not necessary for a tester to create a new account or set up a separate secret just to run the app locally. This is a deliberate exception for a non-production demo/testing project.

I am aware of the risks of exposing secrets in GitHub, but in this case it is an intentional, limited exception and not a production environment or real deployment.

## How to run locally

### With docker

Steps:

1. Run: `docker compose up`
2. Access: `http://localhost:3000` in your browser.

### Without docker

Steps:

1. Run `bundle install`
2. Run `bin/dev`
3. Access `http://localhost:3000` in your browser.
