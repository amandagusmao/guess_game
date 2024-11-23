FROM node:18-alpine AS react-build

WORKDIR /app

COPY package*.json  .

RUN npm install

COPY . .

ENV REACT_APP_BACKEND_URL="http://localhost:30050"

RUN npm run build

FROM nginx:stable-alpine

COPY --from=react-build /app/build /usr/share/nginx/html

COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
