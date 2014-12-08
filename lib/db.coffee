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
        if user.username is username
          callback user

    getEverybody: (callback) ->
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
        console.log "getTOUTELMONDE " + test

      .on 'end', ->
        console.log "End of getEverybody"
        callback listUsers
      .on 'error', (err) ->
        callback err if callback and typeof (callback) is "function"

 
    set: (username, user, callback) ->
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
        if users_by_email.emailname is emailname
          callback users_by_email
      .on 'error', (err) ->
        callback err if callback and typeof (callback) is "function"
      .on 'end', ->
        callback 'end!'
    set: (emailname, users_by_email, callback) ->
      ops = for k, v of users_by_email
        continue if k is 'emailname'
        type: 'put'
        key: "users_by_email:#{emailname}:#{k}"
        value: v