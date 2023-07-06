FROM nginx:1.24.0-alpine
ARG RELEASE_VERSION=dev
COPY nginx.conf /etc/nginx/nginx.conf
COPY ./manifest /manifest
RUN VERSION=$(echo "${RELEASE_VERSION}" | sed 's/release\///') &&\
    sed -i -e "s|<VERSION>|${VERSION}|" /manifest/root.yaml
CMD nginx -g 'daemon off;'
