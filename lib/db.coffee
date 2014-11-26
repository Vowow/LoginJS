
level = require 'level'

module.exports = (db="#{__dirname}../db") ->
  db = level db if typeof db is 'string'
  close: (callback) ->
    console.log
    db.close callback
  users:
    get: (username, callback) ->
      user = {}
      db.createReadStream
        get: "users:#{username}:"
        get: "users_by_email:#{email}"
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
      ops = for k, v of user
        continue if k is 'username'
        type: 'put'
        key: "users:#{username}:#{k}"
        value: v
      db.batch ops, (err) ->
        callback err
    del: (username, callback) ->
      # TODO
