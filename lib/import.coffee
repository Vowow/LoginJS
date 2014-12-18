fs = require "fs"
parse = require "csv-parse"
parser = parse(delimiter: ",")
source = fs.createReadStream("./DB/dbin.csv")
output = []
mydb = require "../lib/db.coffee"

module.exports = (newUser) ->
  mydb = newUser
  # catch erros
  # read file
  source.on "error", ->
    console.log "ERROR :" + error.message
  #password
  parser.on "error", ->
      console.log "ERROR :" + error.message

  # Save a user in output during readable action
  parser.on "readable", ->
    output.push record  while record = parser.read()
    console.log "READ"

  #mydb.users.on "end!", ->
  #  mydb.close

  # Save one user in database
  WriteDataBase = (myuser) ->
        console.log "WRITE"

        console.log "gonna register"
        mydb.users.set myuser[0],
          password: myuser[4]
          name: myuser[1]
          email: myuser[3]
          lastname: myuser[2]
        , (err) ->
          console.log 'error set user:' + err if err
        mydb.emails.set myuser[3],
          username: myuser[0]
        , (err) ->
          console.log 'error set mail:' + err if err
        mydb.emails.get myuser[3]
        , (email) ->
           console.log email
        mydb.users.get myuser[0]
        , (user) ->
            console.log user
            console.log user

  # Save users in databe
  parser.on "finish", ->
    i = 0
    while i < output.length
      myuser = output[i]
      WriteDataBase myuser
      console.log "user :"+  myuser[0]
      ++i
  
  importUser: () ->
    source.pipe parser