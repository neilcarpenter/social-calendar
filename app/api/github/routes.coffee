creds      = require 'app/creds'
bodyParser = require 'body-parser'
GitHubApi  = require 'github'

github = new GitHubApi version: "3.0.0"
github.authenticate
	type   : "oauth"
	key    : creds.github.client_id
	secret : creds.github.client_secret

###
@param token = access token
@param user  = str username to get activity for
###
getUserEvents = (req, res) ->

	github.authenticate
		type  : "oauth"
		token : req.body.token

	github.events.getFromUser { user: req.body.user }, (errGh, resGh) ->
		res.json events : resGh

setup = (app) ->
	app.use bodyParser()

	app.post '/api/github', getUserEvents

module.exports = setup
