# --- Builder Stage ---
FROM alpine:3.21.3 AS downloader

ARG TARGETOS=linux
ARG TARGETARCH=amd64
ARG TARGETVARIANT=""
ARG VERSION

ENV BUILDX_ARCH="${TARGETOS}_${TARGETARCH}${TARGETVARIANT}"

RUN apk update && apk add --no-cache wget unzip \
    && mkdir /tmp/pocketbase \
    && wget "https://github.com/pocketbase/pocketbase/releases/download/v${VERSION}/pocketbase_${VERSION}_${BUILDX_ARCH}.zip" -O /tmp/pocketbase/pocketbase.zip \
    && unzip /tmp/pocketbase/pocketbase.zip -d /tmp/pocketbase/ \
    && rm /tmp/pocketbase/pocketbase.zip \
    && chmod +x /tmp/pocketbase/pocketbase \
    && apk del wget unzip

# --- Final Stage ---
FROM alpine:3.21.3

RUN apk update && apk add --no-cache ca-certificates \
    && rm -rf /var/cache/apk/*

EXPOSE 8090

WORKDIR /pb

COPY --from=downloader /tmp/pocketbase/pocketbase /pb/pocketbase

ENTRYPOINT ["/pb/pocketbase", "serve", "--http=0.0.0.0:8090", "--dir", "/pb/pb_data", "--publicDir", "/pb/pb_public", "--hooksDir", "/pb/pb_hooks", "--migrationsDir", "/pb/pb_migrations"]
