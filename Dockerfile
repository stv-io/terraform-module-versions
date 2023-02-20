FROM library/golang:1.19 AS builder
RUN git clone -b 3.1.14 https://github.com/keilerkonzept/terraform-module-versions.git /terraform-module-versions
WORKDIR /terraform-module-versions
RUN go get -u github.com/keilerkonzept/terraform-module-versions \
    && go mod vendor \
    && CGO_ENABLED=0  go build -tags netgo -ldflags=-w \
    && chmod +x terraform-module-versions
# RUN go mod vendor && go mod tidy && CGO_ENABLED=0 go install -a -tags netgo -ldflags=-w

FROM library/alpine:3.17.2
RUN apk add --no-cache -q bash==5.2.15-r0 jq==1.6-r2
COPY --from=builder /terraform-module-versions/terraform-module-versions /bin/terraform-module-versions
ENTRYPOINT [ "terraform-module-versions" ]
