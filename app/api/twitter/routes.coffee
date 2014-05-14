creds      = require 'app/creds'
twitter    = require 'twitter'
bodyParser = require 'body-parser'

getTweets = (req, res) ->

	params =
		user_id          : req.body.user_id
		count            : 10
		include_entities : true

	twit = new twitter
		consumer_key        : creds.twitter.consumer_key
		consumer_secret     : creds.twitter.consumer_secret
		access_token_key    : req.body.token
		access_token_secret : req.body.tokenSecret

	twit.get '/statuses/user_timeline.json', params, (data) ->
		res.json tweets : data

setup = (app) ->
	app.use bodyParser()

	app.post '/api/twitter', getTweets

module.exports = setup
