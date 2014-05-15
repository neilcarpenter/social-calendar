config           = require "app/config"
creds            = require "app/creds"
cookieParser     = require "cookie-parser"
session          = require "express-session"
passport         = require "passport"
FacebookStrategy = require("passport-facebook").Strategy

passport.serializeUser (user, done) -> done(null, user)
passport.deserializeUser (obj, done) -> done(null, obj)

passport.use new FacebookStrategy {
	clientID     : creds.facebook.client_id,
	clientSecret : creds.facebook.client_secret,
	callbackURL  : "#{config.BASE_PATH}/auth/facebook/callback"
	},
	(accessToken, refreshToken, profile, done) ->

		session.facebookToken = accessToken

		process.nextTick -> return done(null, profile)

auth         = passport.authenticate('facebook', { scope: 'read_stream' })
authCallback = passport.authenticate('facebook', { successRedirect: '/auth/facebook/callback/done', failureRedirect: '/auth/facebook/error' })

renderCallback = (req, res) ->
	if req.user
		data =
			token    : session.facebookToken
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

	app.get '/auth/facebook', auth
	app.get '/auth/facebook/callback', authCallback
	app.get '/auth/facebook/callback/done', renderCallback
	app.get '/auth/facebook/error', error

module.exports = setup
