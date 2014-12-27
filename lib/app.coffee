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
csv = require 'csv'
fs = require 'fs'
db = require '../lib/db'
parse = require 'csv-parse'
importCSV = require '../lib/import'
exportCSV = require '../lib/export'
mydb = db './DB'


app = express()
server = http.Server(app)
io = require("socket.io")(server)

sock = []

io.on 'connectinon', (socket) ->
  sockets.push socket
  socket.on 'login', (data) -> #ne servirait à rien
  console.log "data"




app.set 'views', __dirname + '/../views'
app.set 'view engine', 'jade'
app.use serve_favicon "#{__dirname}/../public/favicon.ico"
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser 'toto'
app.use methodOverride '_method'
app.use session secret: 'toto', resave: true, saveUninitialized: true

#middle ware
app.use (req, res, next) ->
  req.session.count ?= 0
  req.session.count++
  req.session.history ?= []
  req.session.history.push req.urlencoded
  for socket, i in sock
    console.log 'emit logs'
    socket.emit 'logs',
      username: req.session.username or 'anonymous'
      count: req.session.count
      url: req.url
  next()

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
  console.log req.session.username
  if req.session.username
    for socket, i in sock
      socket.emit 'login',
        username: req.session.username
        crdate: Date.now()
        count: req.session.count
  else
    imt = importCSV mydb
    imt.importUser()
  res.header('Access-Control-Allow-Credentials', 'true');
  res.render 'index', {title: 'Express', username: req.session.username}

app.post "/login", (req, res, next) ->
  mySession = undefined
  mySession = req.session
  console.log "LOGIN"
  mydb.emails.get req.body.username, (email) ->
    console.log "EMAIL"
    if email.emailname is req.body.username
      mydb.users.get email.username, (user) ->
        console.log user.username
        if user.password is req.body.password
          session.username = req.body.username
          res.json
            username: user.username
            password: user.password
            email: user.email

        else
          console.log "FAIL by email"
          res.json
            username: user.username
            password: user.password

    else
      mydb.users.get req.body.username, (user) ->
        console.log "login par username"
        if user.username is req.body.username and user.password is req.body.password
          req.session.username = req.body.username
          res.json
            username: user.username
            password: user.password

        else
          console.log "FAIL by name"
          res.json login: "failed"

    return


app.post '/signup', (req, res, next) ->
  mydb.users.set req.body.username,
    password: req.body.password
    firstname: req.body.firstname
    lastname: req.body.lastname
  , (err) ->
    mydb.emails.set req.body.email,
    username: req.body.username
  , (err) ->
    mydb.emails.get req.body.email
  , (email) ->
    mydb.users.get req.body.username
  , (user) ->

  res.json
    mode: 'signup'
    username: req.session.username
    password: req.session.password
    email: req.session.email
    firstname: req.session.firstname
    res.redirect '/'

app.post '/logout', (req, res, next) ->
  req.session.destroy()
  res.redirect '/'

app.use serve_index "#{__dirname}/../public"
if process.env.NODE_ENV is 'development'
  app.use errorhandler()



module.exports = app
