config         = require "../../config"
creds          = require "../../creds"
cookieParser   = require "cookie-parser"
session        = require "express-session"
passport       = require "passport"
GithubStrategy = require("passport-github").Strategy

passport.serializeUser (user, done) -> done(null, user)
passport.deserializeUser (obj, done) -> done(null, obj)

passport.use new GithubStrategy {
	clientID     : creds.github.client_id,
	clientSecret : creds.github.client_secret,
	callbackURL  : "#{config.BASE_PATH}/auth/github/callback"
	},
	(accessToken, refreshToken, profile, done) ->

		session.githubToken    = accessToken
		session.githubUsername = profile.username

		process.nextTick -> return done(null, profile)

auth         = passport.authenticate('github', { scope : ["public_repo", "repo", "repo:status", "gist"] })
authCallback = passport.authenticate('github', { successRedirect: '/auth/github/callback/done', failureRedirect: '/auth/github/error' })

renderCallback = (req, res) ->
	if req.user
		data =
			token    : session.githubToken
			provider : req.user.provider
			name     : req.user.displayName
			username : session.githubUsername
			id       : req.user.id

	res.render "auth/callback", data or {}

error = (req, res) ->
	res.render "errors/authError"

setup = (app) ->
	app.use cookieParser()
	app.use session({ secret: 'what up' })
	app.use passport.initialize()
	app.use passport.session()

	app.get '/auth/github', auth
	app.get '/auth/github/callback', authCallback
	app.get '/auth/github/callback/done', renderCallback
	app.get '/auth/github/error', error

module.exports = setup
