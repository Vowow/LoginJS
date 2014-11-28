
level = require 'level'

module.exports = (db="#{__dirname}./db") ->
  db = level db if typeof db is 'string'
  console.log "INSIDE : 1"
  close: (callback) ->
    console.log
    db.close callback
  users:
    get: (username, callback) ->
      user = {}
      console.log "INSIDE : 2"
      db.createReadStream
        get: "users:#{username}:"
        # get: "users_by_email:#{email}"
      .on 'data', (data) ->
        [_, username,email, key] = data.key.split ':'
        user.username ?= username
        user.email ?= email
        user[key] = data.value


      .on 'error', (err) ->
        callback err
      .on 'end', ->
        callback null, user
    set: (username, user, callback) ->
      console.log "INSIDE : 3"
      ops = for k, v of user
        continue if k is 'username'
        type: 'put'
        key: "users:#{username}:#{k}"
        value: v
      db.batch ops, (err) ->
        callback err
    del: (username, callback) ->
      # TODO
