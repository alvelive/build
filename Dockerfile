FROM alpine

RUN apk add --no-cache curl

CMD ["curl", "https://www.google.com"]
