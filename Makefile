IMAGENAME = gasbuddy/haproxy-multibinder-confd

all: build

build:
	docker build -t $(IMAGENAME) .

clean:
	docker images | awk -F' ' '{if ($$1=="$(IMAGENAME)") print $$3}' | xargs -r docker rmi

test:
	docker run --rm --name haproxy-test -it $(IMAGENAME)

publish:
	docker push $(IMAGENAME)