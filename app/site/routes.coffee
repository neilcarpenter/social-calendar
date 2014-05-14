#Here's a set of routes for the full HTML pages on our site
express     = require 'express'
contentHome = require 'app/content/home.json'

home = (req, res) ->
	res.render "site/home", contentHome

about = (req, res) ->
	res.render "site/about"

error = (req, res) ->
	res.render "site/error"

setup = (app) ->
	app.use(express.static(__dirname + '../../public'))
	app.get '/', home
	app.get '/about', about
	app.get '/error', error

module.exports = setup
