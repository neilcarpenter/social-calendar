creds      = require 'app/creds'
bodyParser = require 'body-parser'
ig         = require('instagram-node').instagram()

ig.use
	client_id     : creds.instagram.client_id
	client_secret : creds.facebook.client_secret

###
@param token   = IG access token
@param user_id = IG user ID to get posts of
###
getPosts = (req, res) ->

	ig.use
		access_token : req.body.token

	params =
		count : 50

	ig.user_media_recent req.body.user_id, params, (err, medias, pagination, limit) ->
		if !medias
			return res.send(500, 'error')
		res.json posts : medias

setup = (app) ->
	app.use bodyParser()

	app.post '/api/instagram', getPosts

module.exports = setup
