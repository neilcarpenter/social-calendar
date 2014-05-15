creds      = require 'app/creds'
bodyParser = require 'body-parser'
GitHubApi  = require 'github'

github = new GitHubApi version: "3.0.0"

###
@param token
@param user
###
getUserEvents = (req, res) ->

	github.authenticate
		type  : "oauth"
		token : req.body.token

	github.events.getFromUser { user: req.body.user }, (err, events) ->
		res.json events : events

setup = (app) ->
	app.use bodyParser()

	app.post '/api/github', getUserEvents

module.exports = setup
