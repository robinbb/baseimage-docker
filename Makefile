NAME = robinbb/phusion-base-bionic
VERSION = 0.11

.PHONY: all build test tag_latest release ssh

all: build

build:
	docker build -t $(NAME):$(VERSION) --rm image

test:
	env NAME=$(NAME) VERSION=$(VERSION) ./test/runner.sh

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	printf "%s" "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin || exit 1
	docker push $(NAME)
	@echo "*** Don't forget to create a tag by creating an official GitHub release."

test_release:
	echo test_release
	env

test_master:
	echo test_master
	env
