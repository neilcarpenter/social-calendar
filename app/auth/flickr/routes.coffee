config         = require "../../config"
creds          = require "../../creds"
cookieParser   = require "cookie-parser"
session        = require "express-session"
passport       = require "passport"
FlickrStrategy = require("passport-flickr").Strategy

passport.serializeUser (user, done) -> done(null, user)
passport.deserializeUser (obj, done) -> done(null, obj)

passport.use new FlickrStrategy {
	consumerKey    : creds.flickr.client_id,
	consumerSecret : creds.flickr.client_secret,
	callbackURL    : "#{config.BASE_PATH}/auth/flickr/callback"
	},
	(token, tokenSecret, profile, done) ->

		session.flickrToken       = token
		session.flickrTokenSecret = tokenSecret

		process.nextTick -> return done(null, profile)

auth         = passport.authenticate('flickr')
authCallback = passport.authenticate('flickr', { successRedirect: '/auth/flickr/callback/done', failureRedirect: '/auth/flickr/error' })

renderCallback = (req, res) ->
	if req.user
		data =
			token       : session.flickrToken
			tokenSecret : session.flickrTokenSecret
			provider    : req.user.provider
			name        : req.user.displayName
			id          : req.user.id

	res.render "auth/callback", data or {}

error = (req, res) ->
	res.render "errors/authError"

setup = (app) ->
	app.use cookieParser()
	app.use session({ secret: 'what up' })
	app.use passport.initialize()
	app.use passport.session()

	app.get '/auth/flickr', auth
	app.get '/auth/flickr/callback', authCallback
	app.get '/auth/flickr/callback/done', renderCallback
	app.get '/auth/flickr/error', error

module.exports = setup
