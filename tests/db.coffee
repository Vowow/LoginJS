
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

  it 'Checking Email/password', (next) ->
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
        user.email.should.eql 'legmas@ece.fr'
        user.password.should.eql 'password'
        client.close()
        next()

  it 'get only a single user', (next) ->
    {users} = db "/tmp/webapp"
    users.set 'wdavidw',
      lastname: 'Worms'
      firstname: 'David'
    , (err) ->
      return next err if err
      users.set 'toto',
        lastname: 'Toto'
        firstname: 'My'
        email: 'toto@adaltas.com'
      , (err) ->
        return next err if err
        users.get 'wdavidw', (err, user) ->
          return next err if err
          user.username.should.eql 'wdavidw'
          user.lastname.should.eql 'Worms'
          should.not.exists user.email
          next()