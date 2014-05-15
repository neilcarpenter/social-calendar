config           = require "app/config"
creds            = require "app/creds"
cookieParser     = require "cookie-parser"
session          = require "express-session"
passport         = require "passport"
InstagramStrategy = require("passport-instagram").Strategy

passport.serializeUser (user, done) -> done(null, user)
passport.deserializeUser (obj, done) -> done(null, obj)

passport.use new InstagramStrategy {
	clientID     : creds.instagram.client_id,
	clientSecret : creds.instagram.client_secret,
	callbackURL  : "#{config.BASE_PATH}/auth/instagram/callback"
	},
	(accessToken, refreshToken, profile, done) ->

		session.instagramToken = accessToken

		process.nextTick -> return done(null, profile)

auth         = passport.authenticate('instagram')
authCallback = passport.authenticate('instagram', { successRedirect: '/auth/instagram/callback/done', failureRedirect: '/auth/instagram/error' })

renderCallback = (req, res) ->
	if req.user
		data =
			token    : session.instagramToken
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

	app.get '/auth/instagram', auth
	app.get '/auth/instagram/callback', authCallback
	app.get '/auth/instagram/callback/done', renderCallback
	app.get '/auth/instagram/error', error

module.exports = setup
