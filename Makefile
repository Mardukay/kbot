VERSION:=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
OS:=linux # os name 
ARCH:=amd64 # architecture name
NAME:="kbot" # app bin name, for windows use <bin_name>.exe

format: # format code 
	gofmt -s -w ./

get: # get dependencies
	go get

test: # test app
	go test -v

build: get format # Build app. Take three arguments: OS=<os_name> ARCH=<arch_name> NAME=<bin_name>; without arguments default OS and ARCH is linux/amd64 and NAME is kbot 
	CGO_ENABLED=0 GOOS=${OS} GOARCH=${ARCH} go build -v -o bin/${NAME} -ldflags "-X=github.com/Mardukay/kbot/cmd.AppVersion=${VERSION}"

clean:
	rm -rf bin/ 