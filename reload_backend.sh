#!/bin/sh

export $(cat .env)

curl -X PUT http://localhost:8080/core/storage/reload?secret=${VUE_APP_DOCHUB_RELOAD_SECRET}