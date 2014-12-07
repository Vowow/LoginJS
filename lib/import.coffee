fs = require "fs"
parse = require "csv-parse"
parser = parse(delimiter: ",")
source = fs.createReadStream("./DB/dbin.csv")
output = []
db = require "../lib/db"

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

  # Save one user in database
  WriteDataBase = (myuser) ->
    mydb.users.get myuser[0]
    , (user) ->
        mydb.users.set myuser[0],
          password: myuser[4]
          name: myuser[2]
          email: myuser[3]
          lastname: myuser[1]
        , (err) ->
          console.log 'error set user:' + err if err

  # Save users in databe
  parser.on "finish", ->
    i = 0
    while i < output.length
      myuser = output[i]
      WriteDataBase myuser
      ++i
  
  importUser: () ->
    source.pipe parser