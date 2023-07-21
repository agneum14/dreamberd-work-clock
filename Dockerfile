FROM node:20-alpine as builder
WORKDIR /app
COPY . .
RUN npm ci
RUN npm run build

FROM node:20
WORKDIR /app
COPY package*.json ./
COPY --from=builder /app/node_modules node_modules/
COPY --from=builder /app/build build/
EXPOSE 3000
CMD ["node", "build/index.js"]
