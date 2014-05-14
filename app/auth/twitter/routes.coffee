config          = require "app/config"
creds           = require "app/creds"
cookieParser    = require "cookie-parser"
session         = require "express-session"
passport        = require "passport"
TwitterStrategy = require("passport-twitter").Strategy

passport.serializeUser (user, done) -> done(null, user)
passport.deserializeUser (obj, done) -> done(null, obj)

passport.use new TwitterStrategy {
	consumerKey    : creds.twitter.consumer_key
	consumerSecret : creds.twitter.consumer_secret
	callbackURL    : "#{config.BASE_PATH}/auth/twitter/callback"
  }, (token, tokenSecret, profile, done) ->
	console.log "authenticated likea bawse"
	process.nextTick -> return done(null, profile)

auth         = passport.authenticate('twitter')
authCallback = passport.authenticate('twitter', { successRedirect: '/test', failureRedirect: '/error' })

test = (req, res) ->
	console.log req.user
	res.render "site/error"

setup = (app) ->
	app.use cookieParser()
	app.use session({ secret: 'what up' })
	app.use passport.initialize()
	app.use passport.session()

	app.get '/auth/twitter', auth
	app.get '/auth/twitter/callback', authCallback
	app.get '/test', test

module.exports = setup
