!/usr/bin/env bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Step 1: We need to have access to a schema that you want to compare against the latest schema in the
# registry. Usually the easiest way to do this is to give a path to a schema file with introspection JSON.
# For example, run a command like this to store your schema in a `schema.json` file:
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# >>> apollo service:download schema.json --endpoint=https://example.graphql.com/api/graphql

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Step 2: Call `apollo service:check --tag=TAG` to generate your schema diff. You'll need to have an
# apollo.config.js file set up properly so your service:check command knows how to locate your schema.
# You'll also need to have a .env file set up with your Engine API key so the Apollo CLI can authenticate
# with the registry. Here's an example of what these two files should look like:
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# --- .env ---
# ENGINE_API_KEY=service:example:AAbbCCddEEffGGhhIIjjKK

# --- apollo.config.js ---
# module.exports = {
#   service: {
#     name: 'example', // the ID of your service in Engine
#     localSchemaFile: './schema.json',
#   },
# };

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Step 3: Set up a Slack app in your workspace and get a wekbook URL from it: https://api.slack.com/apps.
# We'll be use this webhook to post our diff report to your channel. This script has a suggestion on
# formatting that we like personally, though you can format the message any way you'd like.
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# This example script requires 4 files:
# - .env
# - apollo.config.js
# - schema.json
# - shell.sh

# set -euo pipefail

# set the tag you want to compare your current schema's changes against
TAG="master"

# save the output of service:check so we can manipulate the format for our slack message
CHANGES="$(apollo service:check --tag=$TAG || true)"

# Read the output for the different possible change types: FAILURE, WARNING, and NOTICE.
# Chagne types reference:
# https://github.com/apollographql/apollo-tooling/blob/d296e4fca19bb67e2e129e8a6f723846533c920e/packages/apollo/src/commands/service/check.ts#L16
# NOTE: this is brittle. We're relying on the CLI's output to be in a very specific format
# for the `grep` and we're using `cut` to cut off input on the lines before the first 5 spaces.
FAILURES=$(echo "$CHANGES" | (grep FAILURE || true) | cut -d' ' -f2-)
WARNINGS=$(echo "$CHANGES" | (grep WARNING || true) | cut -d' ' -f2-)
NOTICES=$(echo "$CHANGES" | (grep NOTICE || true) | cut -d' ' -f2-)
URL=$(echo "$CHANGES" | (grep : || true | cut -d' ' -f2-)
# Format the slack message payload however you'd like.
# Slack message format reference: https://api.slack.com/docs/message-attachments
function template() {
  echo "## Schema diff changes, compared against \`$TAG\` - [View in Apollo Engine](${URL})  "
  echo "### 🚨 FAILURES 🚨  "
    if [[ -n "$FAILURES" ]]; then
      echo "* ${FAILURES}"
    fi
  echo "### ⚡ WARNINGS ⚡"
    if [[ -n "$WARNINGS" ]]; then
      echo "* ${WARNINGS}"
    fi
echo "### ✔️ NOTICES ✔️"
    if [[ -n "$NOTICES" ]]; then
      echo "* ${NOTICES}"
    fi
}

# Post to your slack webhook.
curl -sfL -X POST -H 'Content-type: application/json' \
  --data "$(template)" \
  https://hooks.slack.com/services/<YOUR_WEBHOOK_ID>
