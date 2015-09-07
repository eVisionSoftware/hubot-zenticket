chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'zenticket', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/zenticket')(@robot)

  it 'registers a respond listener for ticket creation', ->
    expect(@robot.respond).to.have.been.calledWith(/ticketme!/i)