# Install dependencies only when needed
FROM node:18-alpine as deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json package-lock.json* ./
RUN npm install

FROM node:18-alpine as builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . . 

ENV MEDUSA_BACKEND_URL=https://taylormade-backend.tomhoward.codes
RUN npm run build

CMD ["npm", "run", "preview"]

# FROM nginx:latest
# COPY --from=builder /app/public /usr/share/nginx/html

# CMD ["nginx", "-g", "daemon off;"]
