IMAGE_NAME = theta-landing
ECR_QA_REPO = 593793059226.dkr.ecr.ap-northeast-1.amazonaws.com/theta-landing
ECR_PROD_REPO = 746669234290.dkr.ecr.ap-northeast-1.amazonaws.com/theta-landing
AWS_REGION = ap-northeast-1

# Add this line to get the Git short SHA
GIT_SHA := $(shell git rev-parse --short HEAD)

.PHONY: build tag push all login-qa login-prod

login-qa:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin 593793059226.dkr.ecr.$(AWS_REGION).amazonaws.com

login-prod:
	aws ecr get-login-password --profile prod-eks --region $(AWS_REGION) | docker login --username AWS --password-stdin 746669234290.dkr.ecr.$(AWS_REGION).amazonaws.com

build:
	docker build --platform linux/amd64 -t $(IMAGE_NAME):$(GIT_SHA) .

tag: build
	docker tag $(IMAGE_NAME):$(GIT_SHA) $(ECR_QA_REPO):$(GIT_SHA)
	docker tag $(IMAGE_NAME):$(GIT_SHA) $(ECR_PROD_REPO):$(GIT_SHA)

push: login-qa login-prod tag
	docker push $(ECR_QA_REPO):$(GIT_SHA)
	docker push $(ECR_PROD_REPO):$(GIT_SHA)

all: build tag push 
