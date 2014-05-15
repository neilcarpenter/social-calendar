config             = require "app/config"
creds              = require "app/creds"
cookieParser       = require "cookie-parser"
session            = require "express-session"
passport           = require "passport"
FoursquareStrategy = require("passport-foursquare").Strategy

passport.serializeUser (user, done) -> done(null, user)
passport.deserializeUser (obj, done) -> done(null, obj)

passport.use new FoursquareStrategy {
	clientID     : creds.foursquare.client_id,
	clientSecret : creds.foursquare.client_secret,
	callbackURL  : "#{config.BASE_PATH}/auth/foursquare/callback"
	},
	(accessToken, refreshToken, profile, done) ->

		session.foursquareToken    = accessToken

		process.nextTick -> return done(null, profile)

auth         = passport.authenticate('foursquare')
authCallback = passport.authenticate('foursquare', { successRedirect: '/auth/foursquare/callback/done', failureRedirect: '/auth/foursquare/error' })

renderCallback = (req, res) ->
	if req.user
		data =
			token    : session.foursquareToken
			provider : req.user.provider
			name     : req.user.displayName
			id       : req.user.id

	res.render "auth/callback", data or {}

error = (req, res) ->
	res.render "errors/authError"

setup = (app) ->
	app.use cookieParser()
	app.use session({ secret: 'what up' })
	app.use passport.initialize()
	app.use passport.session()

	app.get '/auth/foursquare', auth
	app.get '/auth/foursquare/callback', authCallback
	app.get '/auth/foursquare/callback/done', renderCallback
	app.get '/auth/foursquare/error', error

module.exports = setup
