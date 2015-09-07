# Description:
#   Allows for the creation of ZenDesk tickets based on a discussion in chat.
#
# Dependencies:
#   "hubot-auth": "1.2.0"
#
# Configuration:
#   HUBOT_FLOWDOCK_ORGANIZATION
#   HUBOT_FLOWDOCK_API_TOKEN
#   HUBOT_ZENDESK_USER
#   HUBOT_ZENDESK_TOKEN
#   HUBOT_ZENDESK_SUBDOMAIN
#
# Commands:
#   hubot ticketme! - Takes the current discussion thread, and creates a ticket in ZenDesk with that content.
#   
# Notes:
#   Currently has a hard dependency on the flowdock adapter (https://github.com/flowdock/hubot-flowdock)
#
# Author:
#   erikvanbrakel (https://github.com/erikvanbrakel)

module.exports = (robot) ->

    flowdock = 
        organization: process.env.HUBOT_FLOWDOCK_ORGANIZATION
        api_token: process.env.HUBOT_FLOWDOCK_API_TOKEN

    zendesk = 
        user: process.env.HUBOT_ZENDESK_USER
        api_token: process.env.HUBOT_ZENDESK_TOKEN
        subdomain: process.env.HUBOT_ZENDESK_SUBDOMAIN

    unless flowdock.organization?
        robot.logger.error "hubot-zenticket included, but missing HUBOT_FLOWDOCK_ORGANIZATION"
  
    unless flowdock.api_token?
        robot.logger.error "hubot-zenticket included, but missing HUBOT_FLOWDOCK_API_TOKEN"

    unless zendesk.user?
        robot.logger.error "hubot-zenticket included, but missing HUBOT_ZENDESK_USER"

    unless zendesk.api_token?
        robot.logger.error "hubot-zenticket included, but missing HUBOT_ZENDESK_TOKEN"

    unless zendesk.subdomain?
        robot.logger.error "hubot-zenticket included, but missing HUBOT_ZENDESK_SUBDOMAIN"

    robot.respond /ticketme!/i, (msg) ->

        room = msg.message.metadata.room
        thread_id = msg.message.metadata.thread_id

        if not thread_id
            msg.send "Can't create a ticket without a thread, sorry man."
            return

        if not room
            robot.logger.error "Can't ticket something in private messages"
            return

        flow = robot.adapter.flowFromParams({room: room})

        if not flow
            robot.logger.error "Can't find a matching flow for #{room}"
            return

        msg.http("https://api.flowdock.com/flows/#{process.env.HUBOT_FLOWDOCK_ORGANIZATION}/#{flow.name.toLowerCase()}/threads/#{thread_id}/messages")
            .auth("#{process.env.HUBOT_FLOWDOCK_API_TOKEN}")
            .get() (err, messages, body) ->
                if err
                    robot.logger.error "Error querying messages: #{err}"
                    msg.send "Woops"
                    return

                msgs = JSON.parse(body)

                ticketContents = ""
                for message in msgs
                    user = robot.brain.userForId(message.user)
                    ticketContents += "#{user.name}: \n#{message.content}\n"

                msg.send "Will create ticket with this: #{ticketContents}"

                data = JSON.stringify({ ticket: { requester: "Hubot", subject: "Ticket from flowdock", comment: {body: ticketContents }}})
                msg.http("https://#{process.env.HUBOT_ZENDESK_SUBDOMAIN}.zendesk.com/api/v2/tickets.json")
                    .auth("#{HUBOT_ZENDESK_USER}/token","#{HUBOT_ZENDESK_TOKEN}")
                    .header("Content-Type", "application/json")
                    .post(data) (err, resp, body) ->
                        if err
                            robot.logger.error "Error creating ticket: #{err}"
                            msg.send "Something went wrong."
                            return
                        msg.send "Ticket created."

