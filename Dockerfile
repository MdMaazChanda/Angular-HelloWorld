FROM node:latest as build
WORKDIR /angular
COPY . /angular
RUN npm install
RUN npm run build

FROM nginx:alpine as webserver
COPY --from=build /angular/dist/angular-hello-world /usr/share/nginx/html