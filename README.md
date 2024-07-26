Overview

The Chat System API allows you to manage chat applications, chats, and messages. It includes functionality for creating, updating, retrieving, and searching messages within chats. The API is designed to be used in conjunction with a Rails application and leverages Redis, MySQL, and Elasticsearch.
Requirements

    Ruby on Rails
    MySQL 8.0
    Redis
    Elasticsearch 8.3.0

Setup
Configuration

Docker Setup

You can use Docker to run the services:

    docker-compose up

This command will start the following services:

    MySQL (db)
    Redis
    Elasticsearch
    Rails application (web)
    Sidekiq for background jobs

API Endpoints

Applications

Create Application

POST /applications

    curl --location 'http://localhost:3000/applications' \
    --header 'Content-Type: application/json' \
    --data '{
        "application" : {
            "name" : "application test"
        }
    }'

Update Application

PUT /applications

    curl --location --request PUT 'http://localhost:3000/applications/{application_token}' \
    --header 'Content-Type: application/json' \
    --data '{
        "application" : {
            "name" : "application 32 test"
        }
    }'


Get Application by Token

GET /applications/

    curl --location 'http://localhost:3000/applications/{application_token}'



List Applications

GET /applications

    curl --location 'http://localhost:3000/applications/'


Chats

Create Chat

POST /applications/
/chats

    curl --location --request POST 'http://localhost:3000/applications/{application_token}/chats'


Get Chat by Number

GET /applications/
/chats/

    curl --location 'http://localhost:3000/applications/{application_token}/chats/{chat_number}'


List Chats for an Application

GET /applications/
/chats


    curl --location 'http://localhost:3000/applications/{application_token}/chats'


Messages

Create Message

POST /applications/
/chats/
/messages


    curl --location 'http://localhost:3000/applications/{application_token}/chats/{chat_number}/messages' \
    --header 'Content-Type: application/json' \
    --data '{"message": {"body": "Your test body here"}}'


Get Message by Number

GET /applications/
/chats/
/messages/

    curl --location 'http://localhost:3000/applications/{application_token}/chats/{chat_number}/messages/{message_number}'


Update Message

PUT /applications/
/chats/
/messages/


    curl --location --request PUT 'http://localhost:3000/applications/{application_token}/chats/{chat_number}/messages/{message_number}' \
    --header 'Content-Type: application/json' \
    --data '{"message": {"body": "Your test body here"}}'


List Messages for a Chat

GET /applications/
/chats/
/messages

    curl --location 'http://localhost:3000/applications/{application_token}/chats/{chat_number}/messages/'


Search Messages

GET /applications/
/chats/
/messages/search


    curl --location 'http://localhost:3000/applications/{application_token}/chats/1/messages/search?query=test' \
    --header 'Content-Type: application/json'
