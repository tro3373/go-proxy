NAME := go-proxy
VERSION := v0.0.1
# REVISION := $(shell git rev-parse --short HEAD)
OSARCH := "darwin/amd64 linux/amd64"
PACKAGE := github.com/tro3373/$(NAME)

ifndef GOBIN
GOBIN := $(shell echo "$${GOPATH%%:*}/bin")
endif

COBRA := $(GOBIN)/cobra

$(COBRA): ; @go get -v -u github.com/spf13/cobra/cobra

.DEFAULT_GOAL := run

.PHONY: init-gen
init-gen: $(COBRA)
	@go mod init $(PACKAGE) \
	&& $(COBRA) init --pkg-name $(PACKAGE)

.PHONY: add-hello
add-hello: $(COBRA)
	@$(COBRA) add hello

.PHONY: deps
deps:
	@go list -m all

.PHONY: tidy
tidy:
	@go mod tidy

.PHONY: build
build:
	# @env GOOS=linux GOARCH=amd64 go build -ldflags="-s -w"
	@env GOOS=windows GOARCH=amd64 go build

.PHONY: build-gui
build-gui:
	@env GOOS=windows GOARCH=amd64 go build -ldflags "-H windowsgui" # No log shown

# .PHONY: build-lambda
# build-lambda:
# 	@env GOOS=linux go build -ldflags="-s -w" -o bin/front ./lambda/front.go
#
.PHONY: clean
clean:
	rm -rf ./bin logs stress

.PHONY: help
help:
	@go run ./main.go --help

.PHONY: run
run:
	@go run ./main.go
