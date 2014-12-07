fs = require "fs"
stringify = require "csv-stringify"
csv = require "csv"
toString = stringify(delimiter: ";")
data = ""
wstream = fs.createWriteStream("./DB/dbexport.csv",
  flags: "a"
)
module.exports = (arrayToSave) ->
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
    console.log "Number of Users to save : " + arrayToSave.length
    while i < arrayToSave.length
      toString.write arrayToSave[i]
      console.log "user saved : " + arrayToSave
      ++i

    toString.end()
    wstream.end()