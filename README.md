# hubot-zenticket

A hubot script that interacts with the ZenDesk API to create a ticket out of a conversation.

See [`src/zenticket.coffee`](src/zenticket.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-zenticket --save`

Then add **hubot-zenticket** to your `external-scripts.json`:

```json
[
  "hubot-zenticket"
]
```

## Configuration

### Setting API keys
Currently, this plugin relies heavily on the [`https://github.com/flowdock/hubot-flowdock`](flowdock adapter). As such, the `HUBOT_FLOWDOCK_API_TOKEN` environment variable should contain a token which allows access to the FlowDock API for collecting thread information. Also set `HUBOT_FLOWDOCK_ORGANIZATION` so the plugin knows which organization to query.

To be able to create a ticket in ZenDesk, please set the `HUBOT_ZENDESK_API_TOKEN`, `HUBOT_ZENDESK_SUBDOMAIN` and `HUBOT_ZENDESK_USER`.
