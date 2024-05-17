FROM node:20-alpine AS base

WORKDIR /usr/src/app

RUN apk add --no-cache git libc6-compat

COPY package.json yarn.lock ./

RUN \
  --mount=type=cache,target=/usr/src/.yarn-cache \
  --mount=type=secret,id=npmrc,target=/usr/src/app/.npmrc \
  YARN_CACHE_FOLDER=/usr/src/.yarn-cache yarn install --frozen-lockfile
