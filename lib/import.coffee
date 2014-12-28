fs = require "fs"
parse = require "csv-parse"
parser = parse(delimiter: ",")
source = fs.createReadStream("./DB/dbin.csv")
stream = fs.createReadStream("./DB/dbin.json")
JSONStream = require "JSONStream"
es = require "event-stream"
output = []
mydb = require "../lib/db.coffee"
format =""
module.exports = (newUser, format) ->
  mydb = newUser

  source.on "error", ->
    console.log "ERROR :" + error.message
  parser.on "error", ->
      console.log "ERROR :" + error.message


  parser.on "readable", ->
    output.push record  while record = parser.read()

  getStream = ->
    parserJson = JSONStream.parse("*")
    stream.pipe parserJson

  WriteDataBase = (myuser) ->
        mydb.users.set myuser[0],
          password: myuser[4]
          name: myuser[1]
          email: myuser[3]
          lastname: myuser[2]
        , (err) ->
        mydb.emails.set myuser[3],
          username: myuser[0]
        , (err) ->
        mydb.emails.get myuser[3]
        , (email) ->
        mydb.users.get myuser[0]
        , (user) ->

  parser.on "finish", ->
    i = 0
    while i < output.length
      myuser = output[i]
      WriteDataBase myuser
      console.log myuser
      ++i

  importUser: () ->
    if format is "json"
      getStream().pipe es.mapSync((data) ->
          dataStore = [data.username, data.email, data.password, data.firstname, data.lastname]
          WriteDataBase dataStore
      )
    else
    source.pipe parser
