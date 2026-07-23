FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm test

FROM node:20-alpine
WORKDIR /app
RUN addgroup -S app && adduser -S app -G app
COPY --from=builder /app ./
RUN rm -rf node_modules && npm install --omit=dev
USER app
EXPOSE 3000
CMD ["node", "index.js"]
