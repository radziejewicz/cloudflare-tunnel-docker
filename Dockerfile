FROM --platform=amd64 golang:1.22.3 AS builder

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG CLOUDFLARED_VERSION

ENV GO111MODULE=on \
    CGO_ENABLED=0


WORKDIR /tmp
RUN git clone -q https://github.com/cloudflare/go
WORKDIR /tmp/go/src
RUN git checkout -q ec0a014545f180b0c74dfd687698657a9e86e310 && \
./make.bash
   

WORKDIR /go/src/github.com/cloudflare/cloudflared/

RUN git clone --branch ${CLOUDFLARED_VERSION} --single-branch --depth 1 https://github.com/cloudflare/cloudflared.git && \ 
    cd cloudflared && \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -mod=vendor -ldflags "-w -s -X 'main.Version=${CLOUDFLARED_VERSION}'" github.com/cloudflare/cloudflared/cmd/cloudflared

FROM gcr.io/distroless/base-debian11:nonroot

COPY --from=builder /go/src/github.com/cloudflare/cloudflared/cloudflared /usr/local/bin/

USER nonroot

ENTRYPOINT ["/usr/local/bin/cloudflared", "--no-autoupdate"]
