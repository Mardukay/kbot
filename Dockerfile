FROM quay.io/projectquay/golang:1.21 as builder
ARG OS=linux
ARG ARCH=amd64
ARG NAME=kbot
WORKDIR /go/src/app
COPY . .
RUN make build OS=${OS} ARCH=${ARCH} NAME=${NAME}

FROM scratch
ARG NAME=kbot
ENV name=$NAME
WORKDIR /
COPY --from=builder /go/src/app/bin/* .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs
CMD [ "./kbot" ] 
