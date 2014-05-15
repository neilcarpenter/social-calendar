#Here's a set of routes for the full HTML pages on our site
express     = require 'express'
contentHome = require 'app/content/home.json'

home = (req, res) ->
	res.render "site/home", contentHome

about = (req, res) ->
	res.render "site/about"

setup = (app) ->
	app.get '/', home
	app.get '/about', about

module.exports = setup
