IMAGE = api-haproxy
STAGE_PREFIX = "267230788984.dkr.ecr.us-east-1.amazonaws.com"
PROD_PREFIX = "896521799855.dkr.ecr.us-east-1.amazonaws.com"
TAG = "v1.0.2-rc1"

STAGE_IMAGENAME = $(STAGE_PREFIX)/$(IMAGE):$(TAG)
PROD_IMAGENAME = $(PROD_PREFIX)/$(IMAGE):$(TAG)

all: build

build:
	docker build -t $(STAGE_IMAGENAME) .

clean:
	docker images | awk -F' ' '{if ($$1=="$(STAGE_IMAGENAME)") print $$3}' | xargs -r docker rmi

test:
	docker run --rm --name haproxy-test -it $(STAGE_IMAGENAME)

publish:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(STAGE_PREFIX)
	docker push $(STAGE_IMAGENAME)

publish-prod:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(PROD_PREFIX)
	docker push $(PROD_IMAGENAME)
