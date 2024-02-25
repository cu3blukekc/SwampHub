# syntax=docker/dockerfile:1.4
FROM node:20-alpine as pre
WORKDIR /dochub
COPY dochub/plugins /docker-context/dochub/plugins
RUN cd /docker-context/; \
    find dochub/plugins -name "package.json" -mindepth 0 -maxdepth 4 -exec cp --parents "{}" / \;


FROM node:20-alpine as build

WORKDIR /dochub
ENV PATH /dochub/node_modules/.bin:$PATH
RUN npm install -g recursive-install
COPY ./dochub/package.json /dochub/package.json
COPY ./dochub/package-lock.json /dochub/package-lock.json

COPY --from=pre /dochub/ /dochub/

RUN cd /dochub/plugins && npx recursive-install --skip-root

RUN npm install

COPY ./dochub /dochub/

ENV VUE_APP_DOCHUB_BACKEND_URL=\${VUE_APP_DOCHUB_BACKEND_URL}
ENV VUE_APP_DOCHUB_ROOT_DOCUMENT=\${VUE_APP_DOCHUB_ROOT_DOCUMENT}
ENV VUE_APP_DOCHUB_JSONATA_ANALYZER=\${VUE_APP_DOCHUB_JSONATA_ANALYZER}
ENV VUE_APP_PLANTUML_SERVER=\${VUE_APP_PLANTUML_SERVER}
ENV VUE_APP_DOCHUB_RENDER_CORE=\${VUE_APP_DOCHUB_RENDER_CORE}

RUN npm run build


FROM nginx:1.24.0-alpine as prod

WORKDIR /web

COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /dochub/dist .

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]