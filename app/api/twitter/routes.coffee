test = (req, res) ->
	res.json "site" : "twitter"

setup = (app) ->
	app.get '/api/twitter', test

module.exports = setup
