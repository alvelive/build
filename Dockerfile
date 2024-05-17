FROM node:18-alpine AS base

WORKDIR /usr/src/app

RUN apk add --no-cache git libc6-compat

COPY package.json yarn.lock ./

RUN \
  --mount=type=cache,target=/root/.yarn \
  --mount=type=secret,id=npmrc,target=/app/.npmrc \
  YARN_CACHE_FOLDER=/root/.yarn yarn install --frozen-lockfile
