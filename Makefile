IMAGE = api-haproxy
STAGE_PREFIX = "267230788984.dkr.ecr.us-east-1.amazonaws.com"
PROD_PREFIX = "896521799855.dkr.ecr.us-east-1.amazonaws.com"
TAG = "v4.0.1-dev"
CONFD_SRC = confd/src

STAGE_IMAGENAME = $(STAGE_PREFIX)/$(IMAGE):$(TAG)
PROD_IMAGENAME = $(PROD_PREFIX)/$(IMAGE):$(TAG)

all: build

build:
	$(MAKE) -C $(CONFD_SRC) build-linux
	docker build -t $(STAGE_IMAGENAME) .

clean:
	docker images | awk -F' ' '{if ($$1=="$(STAGE_IMAGENAME)") print $$3}' | xargs -r docker rmi
	$(MAKE) -C $(CONFD_SRC) clean

test:
	docker run --rm --name haproxy-test -it $(STAGE_IMAGENAME)

publish:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(STAGE_PREFIX)
	docker push $(STAGE_IMAGENAME)

publish-prod:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(PROD_PREFIX)
	docker build -t $(PROD_IMAGENAME) .
	docker push $(PROD_IMAGENAME)
