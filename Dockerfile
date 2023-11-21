ARG OS=linux
ARG ARCH=amd64
ARG IMAGE=alpine:latest

FROM quay.io/projectquay/golang:1.21 as builder
ARG OS=linux
ARG ARCH=amd64
ARG NAME=kbot
WORKDIR /go/src/app
COPY . .
RUN make build OS=${OS} ARCH=${ARCH} NAME=${NAME}

FROM --platform=$OS/$ARCH $IMAGE as linux
ARG NAME=kbot
WORKDIR /
COPY --from=builder /go/src/app/bin/* .
ENTRYPOINT [ "./$NAME" ] 

FROM mcr.microsoft.com/windows/nanoserver:ltsc2022-${ARCH} as windows
ARG NAME=kbot
WORKDIR /App
COPY --from=builder /go/src/app/bin/* /App/
CMD ["$NAME"]