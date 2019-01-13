NAME = robinbb/phusion-base-xenial
VERSION = 0.10.3

.PHONY: all build test tag_latest release ssh

all: build

build:
	docker build -t $(NAME):$(VERSION) --rm image

test: build
	env NAME=$(NAME) VERSION=$(VERSION) ./test/runner.sh

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: test tag_latest
	printf "%s" "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin || exit 1
	docker push $(NAME)
	@echo "*** Don't forget to create a tag by creating an official GitHub release."

test_release:
	echo test_release
	env

test_master:
	echo test_master
	env
