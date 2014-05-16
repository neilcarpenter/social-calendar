creds      = require 'app/creds'
bodyParser = require 'body-parser'
Flickr     = require 'flickrapi'

flickrOptions =
	api_key : creds.flickr.client_id
	secret  : creds.flickr.client_secret

###
@param token (optional)
@param tokenSecret (optional)
@param user_id
###
getPhotos = (req, res) ->

	flickrOptions.access_token = req.body.token
	flickrOptions.access_token_secret = req.body.tokenSecret

	Flickr.authenticate flickrOptions, (error, flickr) ->

		params = 
			user_id : req.body.user_id

		flickr.people.getPhotos params, (err, photos) ->
			res.json photos : photos

setup = (app) ->
	app.use bodyParser()

	app.post '/api/flickr', getPhotos

module.exports = setup
