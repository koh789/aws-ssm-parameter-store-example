PROJECT_PARAM_STORE=dummy-param-store-project
PROJECT_PARAM_STORE_TEMPlATE=$(PROJECT_PARAM_STORE)
PROJECT_PARAM_STORE_S3=$(PROJECT_PARAM_STORE)-s3

PROJECT_CROSS_REF=dummy-cross-ref-project
PROJECT_CROSS_REF_TEMPlATE=$(PROJECT_CROSS_REF)
PROJECT_CROSS_REF_S3=$(PROJECT_CROSS_REF)-s3


.PHONY: help
help: ## help 表示 `make help` でタスクの一覧を確認できます
	@echo "------- タスク一覧 ------"
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36mmake %-20s\033[0m %s\n", $$1, $$2}'


.PHONY: cfn-param-store-s3-deploy
cfn-param-store-s3-deploy: ## deploy
	make internal-cfn-deploy CFN_PATH=deployments/cfn/param-store/s3.yml PROJECT_NAME=$(PROJECT_PARAM_STORE) STACK_NAME=$(PROJECT_PARAM_STORE_S3)

.PHONY: cfn-param-store-deploy
cfn-param-store-deploy: ## deploy
	make internal-cfn-deploy CFN_PATH=deployments/cfn/param-store/template.yml PROJECT_NAME=$(PROJECT_PARAM_STORE) STACK_NAME=$(PROJECT_PARAM_STORE_TEMPlATE)

.PHONY: cfn-param-store-update
cfn-param-store-update: ## update
	make internal-cfn-update CFN_PATH=deployments/cfn/param-store/template.yml PROJECT_NAME=$(PROJECT_PARAM_STORE) STACK_NAME=$(PROJECT_PARAM_STORE_TEMPlATE)

.PHONY: cfn-param-store-all-delete
cfn-param-store-all-delete: ## param store all delete
	make internal-cfn-delete STACK_NAME=$(PROJECT_PARAM_STORE_S3)
	make internal-cfn-delete STACK_NAME=$(PROJECT_PARAM_STORE)

.PHONY: cfn-cross-ref-s3-deploy
cfn-cross-ref-s3-deploy: ## deploy
	make internal-cfn-deploy CFN_PATH=deployments/cfn/cross-ref/s3.yml PROJECT_NAME=$(PROJECT_CROSS_REF) STACK_NAME=$(PROJECT_CROSS_REF_S3)

.PHONY: cfn-cross-ref-deploy
cfn-cross-ref-deploy: ## deploy
	make internal-cfn-deploy CFN_PATH=deployments/cfn/cross-ref/template.yml PROJECT_NAME=$(PROJECT_CROSS_REF) STACK_NAME=$(PROJECT_CROSS_REF_TEMPlATE)

.PHONY: cfn-cross-ref-all-delete
cfn-cross-ref-all-delete: ## param store all delete
	make internal-cfn-delete STACK_NAME=$(PROJECT_CROSS_REF_S3)
	make internal-cfn-delete STACK_NAME=$(PROJECT_CROSS_REF)


.PHONY: internal-cfn-deploy
internal-cfn-deploy: # [ args: STACK_NAME, CFN_PATH ]
	aws cloudformation deploy --capabilities CAPABILITY_NAMED_IAM \
	--template $(CFN_PATH) \
	--stack-name $(STACK_NAME) \
	--no-fail-on-empty-changeset \
	--parameter-overrides ProjectName=$(PROJECT_NAME) \
	--tags "Name=$(STACK_NAME)"

.PHONE: internal-cfn-update
internal-cfn-update: # [ args: STACK_NAME, CFN_PATH ]
	aws cloudformation update-stack --capabilities CAPABILITY_NAMED_IAM \
	--template-body file://$(CFN_PATH) \
	--stack-name $(STACK_NAME) \
    --parameters ParameterKey=ProjectName,ParameterValue=$(PROJECT_NAME) \

.PHONY: internal-cfn-delete #  [ args: STACK_NAME ]
internal-cfn-delete: # internal-cfn-delete
	aws cloudformation delete-stack --stack-name $(STACK_NAME)