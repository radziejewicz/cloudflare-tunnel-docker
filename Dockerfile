FROM --platform=amd64 golang:1.25.6 AS builder

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG CLOUDFLARED_VERSION

ENV GO111MODULE=on \
    CGO_ENABLED=0

WORKDIR /go/src/github.com/cloudflare/

RUN git clone --branch ${CLOUDFLARED_VERSION} --single-branch --depth 1 https://github.com/cloudflare/cloudflared.git .

RUN .teamcity/install-cloudflare-go.sh

RUN GOOS=linux GOARCH=${TARGETARCH} PATH="/tmp/go/bin:$PATH" make cloudflared

FROM gcr.io/distroless/base-debian11:nonroot

COPY --from=builder --chown=nonroot /go/src/github.com/cloudflare/cloudflared /usr/local/bin/

USER nonroot

ENTRYPOINT ["/usr/local/bin/cloudflared", "--no-autoupdate"]
