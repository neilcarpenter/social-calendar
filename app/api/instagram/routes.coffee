bodyParser = require 'body-parser'
ig         = require('instagram-node').instagram()

###
@param token
@param user_id
###
getPosts = (req, res) ->

	ig.use
		access_token : req.body.token

	params =
		count : 50

	ig.user_media_recent req.body.user_id, params, (err, medias, pagination, limit) ->
		res.json posts : medias

setup = (app) ->
	app.use bodyParser()

	app.post '/api/instagram', getPosts

module.exports = setup
