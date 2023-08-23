# syntax=docker/dockerfile:1.4
FROM node:16-alpine as pre
WORKDIR /dochub
COPY dochub/plugins /docker-context/dochub/plugins
RUN cd /docker-context/; \
    find dochub/plugins -name "package.json" -mindepth 0 -maxdepth 4 -exec cp --parents "{}" / \;


FROM node:16-alpine as build

WORKDIR /dochub
ENV PATH /dochub/node_modules/.bin:$PATH
RUN npm install -g recursive-install
COPY ./dochub/package.json /dochub/package.json
COPY ./dochub/package-lock.json /dochub/package-lock.json

COPY --from=pre /dochub/ /dochub/
RUN cd /dochub/plugins && npx recursive-install --skip-root

RUN npm install 

COPY ./dochub /dochub/

RUN npm run backend-build


FROM node:16-alpine as prod

WORKDIR /dochub
ENV PATH /dochub/node_modules/.bin:$PATH
RUN npm install -g recursive-install
COPY ./dochub/package.json /dochub/package.json
COPY ./dochub/package-lock.json /dochub/package-lock.json
COPY --from=pre /dochub/ /dochub/

RUN cd /dochub/plugins && npx recursive-install --skip-root
RUN npm install

# TODO: без src не запускается
COPY --from=build /dochub/src ./src
COPY --from=build /dochub/dist ./dist
# тут базовая метамодель DocHub и index.html
COPY --from=build /dochub/public ./public

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]