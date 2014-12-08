
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
global.mydb = db "./DB", { valueEncoding: 'json' }

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
  #import de la database en arrivant sur l'index
  impdb = importCSV mydb
  impdb.importUser()
  res.render 'index', title: 'Express'

app.post '/login', (req, res, next) ->
  
  mydb.emails.get req.body.username,(email) ->
      if email.emailname is req.body.username
        mydb.users.get email.username
        , (user) ->
          if user.password is req.body.password
            res.json
              username: user.username
              password: user.password
          else
            res.json
              login: "failed"
      else
        mydb.users.get req.body.username, (user) ->
          if user.username is req.body.username and user.password is req.body.password
            res.json
              username: user.username
              password: user.password
          else
            res.json
              login: "failed"

app.post '/export', (req, res, next) ->
  #test
  mesUsers = [
    [
      "admin"
      "MASSON"
      "LEGRIS"
      "legmas@ece.fr"
      "password"
    ]
    [
      "user"
      "user1"
      "pedro"
      "pedro@ece.fr"
      "password"
    ]
  ]
  #import de la database en arrivant sur l'index
    #impdb = importCSV mydb
    #impdb.importUser()

  #export de la BDD
  #csvout = exportCSV mesUsers
  #exportUser()

  listUsers = exportCSV mydb.users.getEverybody()
  #console.log "export csv " + listUsers
  listUsers.exportUser()

  #mydb.users.getEverybody (listUsers) ->
  #  listUsers.exportUser()


    


app.use serve_index "#{__dirname}/../public"
if process.env.NODE_ENV is 'development'
  app.use errorhandler()



module.exports = app
