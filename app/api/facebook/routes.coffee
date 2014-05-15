creds      = require 'app/creds'
bodyParser = require 'body-parser'
FB         = require 'fb'

FB.options
	appId     : creds.facebook.client_id
	appSecret : creds.facebook.client_secret

###
@param token   = FB access token
###
getPosts = (req, res) ->

	params =
		limit        : 50
		access_token : req.body.token

	FB.api 'me/feed', params, (result) ->
		if !result or result.error
			return res.send(500, 'error')
		res.json posts : result

setup = (app) ->
	app.use bodyParser()

	app.post '/api/facebook', getPosts

module.exports = setup
