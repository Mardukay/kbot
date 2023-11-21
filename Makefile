APP:=$(shell basename $(shell git remote get-url origin))
REGISTRY:=mardukay
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

#	 build image, default image is linux/amd64, take arguments OS=<os_name> ARCH=<arch_name> NAME=<bin_name>
image:
	docker build --no-cache --progress=plain --target builder --target ${OS} --build-arg OS=${OS} --build-arg ARCH=${ARCH} --build-arg NAME=${NAME} -t ${REGISTRY}/${APP}:${VERSION}-${ARCH} . 

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${ARCH}

clean:
	rm -rf bin/ 
	docker rmi $(shell docker images -q mardukay/kbot.git)