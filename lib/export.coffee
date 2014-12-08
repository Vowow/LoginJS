fs = require "fs"
csv = require "csv"
stringify = require "csv-stringify"
toString = stringify(delimiter: ";")
data = ""
wstream = fs.createWriteStream("./DB/dbexport.csv",
  flags: "a"
)
module.exports = (listUsers) ->
  # Catch error
  toString.on "error", (err) ->
    console.log err.message

  # add rows to data
  toString.on "readable", ->
    data += row  while row = toString.read()

  # Find end of file and write
  toString.on "finish", ->
    console.log "end:" + data
    wstream.write data

  # Export users to CSV file
  exportUser: () ->
    i = 0
    console.log "Number of Users to save : " + listUsers.length
    while i < listUsers.length
      toString.write listUsers[i]
      console.log "user saved : " + listUsers[i]
      ++i

    toString.end()
    wstream.end()