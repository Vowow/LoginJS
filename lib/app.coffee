
http = require 'http'
stylus = require 'stylus'
nib = require 'nib'
express = require 'express'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
methodOverride = require 'method-override'
session = require 'express-session'
errorhandler = require 'errorhandler'
dojo = require 'connect-dojo'
coffee = require 'connect-coffee-script'
serve_favicon = require 'serve-favicon'
serve_index = require 'serve-index'
serve_static = require 'serve-static'
# config = require '../conf/hdfs'
db = require '../lib/db'


app = express()

app.set 'views', __dirname + '/../views'
app.set 'view engine', 'jade'
app.use serve_favicon "#{__dirname}/../public/favicon.ico"
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser 'toto'
app.use methodOverride '_method'
app.use session secret: 'toto', resave: true, saveUninitialized: true

app.use coffee
  src: "#{__dirname}/../views"
  dest: "#{__dirname}/../public"
  bare: true
app.use stylus.middleware
  src: "#{__dirname}/../views"
  dest: "#{__dirname}/../public"
  compile: (str, path) ->
    stylus(str)
    .set('filename', path)
    .set('compress', config?.css?.compress)
    .use nib()
app.use serve_static "#{__dirname}/../public"





app.get '/', (req, res, next) ->
  res.render 'index', title: 'Express'

test = db "./NEWdb"
app.post '/user/login', (req, res, next) ->
  
  
  
  
  test.users.set "Martin",
    lastname: "Worms"
    firstname: "David"
    email: "david@adaltas.com"
  , (err) ->
    return next err if err
  
  console.log "USER: " + req.body.username + " PASS: " + req.body.password

  toto = test.users.get 'wdavid',(err, user) ->
    return next err if err
    console.log "READ : " + " USERNAME " + user.username 



app.use serve_index "#{__dirname}/../public"
if process.env.NODE_ENV is 'development'
  app.use errorhandler()


module.exports = app
