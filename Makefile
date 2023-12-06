APP:=$(shell basename -s .git $(shell git remote get-url origin))
REGISTRY:=mardukay
VERSION:=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
OS:=linux # os name 
ARCH:=amd64 # architecture name
NAME:=kbot
EXT:=""

format: # format code 
	gofmt -s -w ./

get: # get dependencies
	go get

test: # test app
	go test -v

# Build app. Take three arguments: OS=<os_name> ARCH=<arch_name> NAME=<bin_name>; without arguments default OS and ARCH is linux/amd64 and NAME is kbot. OSs list: darwin(apple), linux, windows 
build: get format 
	CGO_ENABLED=0 GOOS=${OS} GOARCH=${ARCH} go build -v -o bin/${NAME}${EXT} -ldflags "-X=github.com/Mardukay/kbot/cmd.AppVersion=${VERSION}"

# Build image, default image is linux/amd64, take arguments OS=<os_name> ARCH=<arch_name> EXT=<extension>(for windows .exe). OSs list: darwin(apple), linux, windows
# For windows use: make image OS=windows ARCH=amd64 EXT=.exe
# For linux use: make image OS=linux ARCH=amd64
# For apple use: make image OS=darwin ARCH=arm64
image:
	docker build --target=${OS} --build-arg OS=${OS} --build-arg ARCH=${ARCH} --build-arg EXT=${EXT} -t ${REGISTRY}/${APP}:${VERSION}-${ARCH} . 

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${ARCH}

clean:
	rm -rf bin/ 
	docker rmi $(shell docker images -q mardukay/kbot)