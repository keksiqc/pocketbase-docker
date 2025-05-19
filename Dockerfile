# --- Builder Stage ---
FROM alpine:3.21.3 as downloader

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

RUN addgroup -S pocketbase && adduser -S -u 1000 pocketbase pocketbase

RUN apk update && apk add --no-cache ca-certificates \
    && rm -rf /var/cache/apk/*

EXPOSE 8090

ENV PB_DATA_DIR="/pb_data"
ENV PB_PUBLIC_DIR="/pb_public"
ENV PB_HOOKS_DIR="/pb_hooks"

WORKDIR ${PB_DATA_DIR}

RUN mkdir -p ${PB_DATA_DIR} ${PB_PUBLIC_DIR} ${PB_HOOKS_DIR} \
    && chown -R pocketbase:pocketbase ${PB_DATA_DIR} ${PB_PUBLIC_DIR} ${PB_HOOKS_DIR}

COPY --from=downloader /tmp/pocketbase/pocketbase /usr/local/bin/pocketbase

USER pocketbase

ENTRYPOINT ["/usr/local/bin/pocketbase", "serve", "--http=0.0.0.0:8090", "--dir", "${PB_DATA_DIR}", "--publicDir", "${PB_PUBLIC_DIR}", "--hooksDir", "${PB_HOOKS_DIR}"]
