# AC Forecast

It get's the weather based on an address or a zipcode.

I'm using two third party services:

- Geocode (To get the zipcode from an address)

- Open Meteo (To get the forecast based on a zipcode)

## Rationale

My understanding: Find the forecast by zipcode and accept an address as input as well. Cache the results by zipcode.

Since we need zipcode for caching it was inevitable to use some "get zipcode by address" API service, so we always gonna have the zipcode either when user provides only the address.

## Approach

When an address is provided we need to know it's zipcode first, so it calls Geocode to get the zipcode by address, later it calls Open Meteo to get the forecast with that zipcode.

It caches the forecast by zipcode, so every new search by the address will still calls Geocode API in order to have the zipcode, but if that zipcode was already requested it get's from the cache avoiding calling the Open Meteo API.

If the search is based on the zipcode it only calls the Open Meteo API and caches the response and use that cache for any other consecutive search with that same zipcode, having no API calls for external services.

I've decided to use turbo_stream in order to show the results, it avoids the whole page being reloaded. As there's just one small piece of the page that will change it's easier for the user to know where the results will be.

## Libs

HTTParty: for the third party API requests as it's very well maintained and easy to use.

## How to run locally

### With docker

Just run: `docker compose up`

### Without docker

Steps:

1. `bundle install`
2. `bin/dev`
3. Access `http://localhost:3000` in your browser.
