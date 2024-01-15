#base phase
FROM node:16-alpine as base
WORKDIR /app
COPY package.json .
RUN npm install --force
COPY . .

#test phase, using yarn instead of npm
FROM base as test
ENTRYPOINT [ "yarn" ]

#build phase, build project to static content
FROM base as build
RUN yarn build

#deploy phase: using nginx to deploy
FROM nginx:stable-alpine as deploy
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]