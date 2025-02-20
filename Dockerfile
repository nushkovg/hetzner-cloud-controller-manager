FROM golang:1.18 as builder
WORKDIR /maschine-controller/src
COPY ./go.mod .
COPY ./go.sum .
RUN go mod download
ADD . .
RUN CGO_ENABLED=0 go build -o hcloud-maschine-controller.bin  .

FROM alpine:3.12
RUN apk add --no-cache ca-certificates bash
COPY --from=builder /maschine-controller/src/hcloud-maschine-controller.bin /bin/hcloud-cloud-controller-manager
ENTRYPOINT ["/bin/hcloud-cloud-controller-manager"]
