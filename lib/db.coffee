level = require 'level'

module.exports = (db="#{__dirname}../db") ->
  db = level db if typeof db is 'string'
  close: (callback) ->
    db.close callback
  users:
    get: (username, callback) ->
      user = {}
      db.createReadStream
        gt: "users:#{username}:"
      .on 'data', (data) ->
        [_, username, key] = data.key.split ':'
        user.username ?= username
        user[key] = data.value
      .on 'error', (err) ->
        callback err
      .on 'end', ->
          callback user

    getAll: (callback) ->
      person = {}
      listUsers = []

      db.createReadStream
        gt: ""
      .on 'data', (data) ->
        [_, username, _] = data.key.split ':'
        person.key = username
        person.value = data.value
        test = [username, data.value]
        listUsers.push test

      .on 'end', ->
        callback listUsers
      .on 'error', (err) ->
        callback err if callback and typeof (callback) is "function"


    set: (username, user, callback) ->
      console.log "SET"
      ops = for k, v of user
        continue if k is 'username'
        type: 'put'
        key: "users:#{username}:#{k}"
        value: v
      db.batch ops, (err) ->
        callback err
    del: (username, callback) ->
  emails:
    get: (emailname, callback) ->
      users_by_email = {}
      db.createReadStream
        gt: "users_by_email:#{emailname}:"
      .on 'data', (data) ->
        [_, emailname, key] = data.key.split ':'
        users_by_email.emailname ?= emailname
        users_by_email[key] = data.value
      .on 'error', (err) ->
        callback err if callback and typeof (callback) is "function"
      .on 'end', ->
          callback users_by_email
    set: (emailname, users_by_email, callback) ->
      console.log "SET"
      ops = for k, v of users_by_email
        continue if k is 'emailname'
        type: 'put'
        key: "users_by_email:#{emailname}:#{k}"
        value: v
      db.batch ops, (err) ->
        callback err if callback and typeof (callback) is "function"
