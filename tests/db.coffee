
rimraf = require 'rimraf'
should = require 'should'
db = require '../lib/db'

describe 'users', ->

  beforeEach (next) ->
    rimraf "/tmp/webapp", next

  it 'insert and get', (next) ->
    client = db "/tmp/webapp"
    client.users.set 'wdavidw',
      lastname: 'Worms'
      firstname: 'David'
      email: 'david@adaltas.com'
    , (err) ->
      return next err if err
      client.users.get 'wdavidw', (err, user) ->
        return next err if err
        user.username.should.eql 'wdavidw'
        user.lastname.should.eql 'Worms'
        client.close()
        next()

  it 'Checking usernname/password', (next) ->
    client = db "/tmp/webapp"
    client.users.set 'admin',
      lastname: 'Masson'
      firstname: 'legris'
      email: 'legmas@ece.fr'
      password: 'password'
    , (err) ->
      return next err if err
      client.users.get 'admin', (err, user) ->
        return next err if err
        user.username.should.eql 'admin'
        user.password.should.eql 'password'
        client.close()
        next()
