# Cineaste Server

Cineaste Server is an small Sinatra app that provides a basic interface for the Cineaste gem. 

## Usage

- Move the folder out of Cineaste
- Change the Cineaste gem source to the current repository (if required)
- `bundle install`
- `rackup` (or `bundle exec rackup` if rackup not found)

## API

The app accepts parameters via the path: `/dictionary/:dictionary/:phrase?voice=''`
- `dictionary` should be the appropriate dictionary folder in S3
- `phrase` is the phrase to be processed
- `voice` is an optional parameter and may be 'male' or 'female'. It determineds which TTS API will be used for generated videos




