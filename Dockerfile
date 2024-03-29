FROM quay.io/projectquay/golang:1.21 as builder
ARG OS=linux
ARG ARCH=amd64
ARG NAME=kbot
ARG EXT=""
WORKDIR /go/src/app
COPY . .
RUN make build OS=${OS} ARCH=${ARCH} NAME=${NAME} EXT=${EXT}

FROM scratch as linux
ENV TELE_TOKEN default
ENV METRICS_HOST default
WORKDIR /
COPY --from=builder /go/src/app/bin/* .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "./kbot", "start" ]

FROM scratch as windows
ENV TELE_TOKEN default
ENV METRICS_HOST default
WORKDIR /
COPY --from=builder /go/src/app/bin/* .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "./kbot.exe", "start" ] 
CMD [ "start" ] 

FROM scratch as darwin
ENV TELE_TOKEN default
ENV METRICS_HOST default
WORKDIR /
COPY --from=builder /go/src/app/bin/* .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "./kbot", "start" ] 
CMD [ "start" ] 