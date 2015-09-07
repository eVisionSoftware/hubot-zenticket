chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'zenticket', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()
      logger: 
        error: sinon.spy()


  it 'registers a respond listener for ticket creation', ->
    require('../src/zenticket')(@robot)
    expect(@robot.respond).to.have.been.calledWith(/ticketme!/i)

  it 'logs an error when HUBOT_FLOWDOCK_ORGANIZATION is not set', ->    
    require('../src/zenticket')(@robot)
    expect(@robot.logger.error).to.have.been.calledWithMatch(/HUBOT_FLOWDOCK_ORGANIZATION/i)

  it 'continues when HUBOT_FLOWDOCK_ORGANIZATION is set', ->
    process.env.HUBOT_FLOWDOCK_ORGANIZATION = 'MyOrg'
    require('../src/zenticket')(@robot)
    expect(@robot.logger.error).to.have.not.been.calledWithMatch(/HUBOT_FLOWDOCK_ORGANIZATION/i)

  it 'logs an error when HUBOT_FLOWDOCK_API_TOKEN is not set', ->    
    require('../src/zenticket')(@robot)
    expect(@robot.logger.error).to.have.been.calledWithMatch(/HUBOT_FLOWDOCK_API_TOKEN/i)

  it 'continues when HUBOT_FLOWDOCK_API_TOKEN is set', ->
    process.env.HUBOT_FLOWDOCK_API_TOKEN = 'MyToken'
    require('../src/zenticket')(@robot)
    expect(@robot.logger.error).to.have.not.been.calledWithMatch(/HUBOT_FLOWDOCK_API_TOKEN/i)

  it 'logs an error when HUBOT_ZENDESK_USER is not set', ->    
    require('../src/zenticket')(@robot)
    expect(@robot.logger.error).to.have.been.calledWithMatch(/HUBOT_ZENDESK_USER/i)

  it 'continues when HUBOT_ZENDESK_USER is set', ->
    process.env.HUBOT_ZENDESK_USER = 'MyToken'
    require('../src/zenticket')(@robot)
    expect(@robot.logger.error).to.have.not.been.calledWithMatch(/HUBOT_ZENDESK_USER/i)

  it 'logs an error when HUBOT_ZENDESK_TOKEN is not set', ->    
    require('../src/zenticket')(@robot)
    expect(@robot.logger.error).to.have.been.calledWithMatch(/HUBOT_ZENDESK_TOKEN/i)

  it 'continues when HUBOT_ZENDESK_TOKEN is set', ->
    process.env.HUBOT_ZENDESK_TOKEN = 'MyToken'
    require('../src/zenticket')(@robot)
    expect(@robot.logger.error).to.have.not.been.calledWithMatch(/HUBOT_ZENDESK_TOKEN/i)

  it 'logs an error when HUBOT_ZENDESK_SUBDOMAIN is not set', ->    
    require('../src/zenticket')(@robot)
    expect(@robot.logger.error).to.have.been.calledWithMatch(/HUBOT_ZENDESK_SUBDOMAIN/i)

  it 'continues when HUBOT_ZENDESK_SUBDOMAIN is set', ->
    process.env.HUBOT_ZENDESK_SUBDOMAIN = 'MyToken'
    require('../src/zenticket')(@robot)
    expect(@robot.logger.error).to.have.not.been.calledWithMatch(/HUBOT_ZENDESK_SUBDOMAIN/i)

