fs = require "fs"
stringify = require "csv-stringify"
csv = require "csv"
createSource = require "stream-json"

stringifier = stringify(delimiter: ",")
data = ""
myformat = "csv"
myjson = ""

source = createSource()
objectCounter = 0

module.exports = (arrayToSave, format) ->
  myformat = format if format
  # on cherche a connaitre le format afin d'exporter en json ou CSV
  if myformat is "json"
    wstream = fs.createWriteStream("./DB/dbexport.json",
      flags: "w"
    )

    source.on "startObject", ->
     ++objectCounter

    source.on "end", ->
        console.log "Found "+ objectCounter+ " objects."

  else
    wstream = fs.createWriteStream("./DB/dbexport.csv",
      flags: "w"
    )

    # on récupere les erreur sur le stringify
    stringifier.on "error", (err) ->
      console.log err.message
      return

    # on push les donné dans le fichier
    stringifier.on "readable", ->
      data += row  while row = stringifier.read()
      return

    stringifier.on "finish", ->
      wstream.write data
      return

  exportUser: () ->
    if myformat is "json"
      myJSON = JSON.stringify({users: arrayToSave})
      wstream.write myJSON
    else
      i = 0
      while i < arrayToSave.length
        stringifier.write arrayToSave[i]
        i++

      stringifier.end()

    wstream.end()
