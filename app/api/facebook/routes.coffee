test = (req, res) ->
	res.json "site" : "facebook"

setup = (app) ->
	app.get '/api/facebook', test

module.exports = setup
