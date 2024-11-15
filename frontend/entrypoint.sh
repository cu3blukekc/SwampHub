#!/bin/sh

set -e
# для передачи env в момент запуска nginx, т.е. с различием по стенду (dev, stage, prod)

PLUGINS_DIR=/web/plugins/plugins

echo "envsubstr for app.js"
APP_FILE=/web/app.js
cp $APP_FILE $APP_FILE.tpl
envsubst '$VUE_APP_DOCHUB_BACKEND_URL $VUE_APP_DOCHUB_ROOT_DOCUMENT $VUE_APP_DOCHUB_JSONATA_ANALYZER $VUE_APP_PLANTUML_SERVER $VUE_APP_DOCHUB_RENDER_CORE' < $APP_FILE.tpl > $APP_FILE
rm $APP_FILE.tpl

FILE=/etc/nginx/nginx.conf
echo "envsubstr for $FILE"
cp $FILE $FILE.tpl
envsubst '$NGINX_BACKEND_LOCATION' < $FILE.tpl > $FILE
rm $FILE.tpl

nginx -g 'daemon off;'

