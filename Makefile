PROJECT_CROSS_REFERENCE=dummy-cross-reference-paramter-project
PROJECT_CROSS_REFERENCE_TEMPLATE=$(PROJECT_CROSS_REFERENCE)
PROJECT_CROSS_REFERENCE_PROFILE=$(PROJECT_CROSS_REFERENCE)-instance-profile
PROJECT_PARAM_STORE=dummy-paramter-store-project
PROJECT_PARAM_STORE_TEMPlATE=$(PROJECT_PARAM_STORE)
PROJECT_PARAM_STORE_PROFILE=$(PROJECT_PARAM_STORE)-instance-profile

.PHONY: help
help: ## help 表示 `make help` でタスクの一覧を確認できます
	@echo "------- タスク一覧 ------"
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36mmake %-20s\033[0m %s\n", $$1, $$2}'


.PHONY: cfn-cross-reference-instance-profile-deploy
cfn-cross-reference-instance-profile-deploy: ## cross reference instance profile deploy
	make internal-cfn-deploy CFN_PATH=deployments/cfn/example1/instance-profile.yml PROJECT_NAME=$(PROJECT_CROSS_REFERENCE) STACK_NAME=$(PROJECT_CROSS_REFERENCE_PROFILE)

.PHONY: cfn-cross-reference-deploy
cfn-cross-reference-deploy: ## cross reference deploy
	make internal-cfn-deploy CFN_PATH=deployments/cfn/example1/template.yml PROJECT_NAME=$(PROJECT_CROSS_REFERENCE) STACK_NAME=$(PROJECT_CROSS_REFERENCE)

.PHONY: cfn-cross-reference-all-delete
cfn-cross-reference-all-delete: ## cross reference all delete
	make internal-cfn-delete STACK_NAME=$(PROJECT_CROSS_REFERENCE_PROFILE)
	make internal-cfn-delete STACK_NAME=$(PROJECT_CROSS_REFERENCE)

.PHONY: cfn-param-store-instance-profile-deploy
cfn-param-store-instance-profile-deploy: ## param store instance profiledeploy
	make internal-cfn-deploy CFN_PATH=deployments/cfn/example2/instance-profile.yml PROJECT_NAME=$(PROJECT_PARAM_STORE) STACK_NAME=$(PROJECT_PARAM_STORE_PROFILE)

.PHONY: cfn-param-store-deploy
cfn-param-store-deploy: ## param store deploy
	make internal-cfn-deploy CFN_PATH=deployments/cfn/example2/template.yml PROJECT_NAME=$(PROJECT_PARAM_STORE) STACK_NAME=$(PROJECT_PARAM_STORE)

.PHONY: cfn-param-store-all-delete
cfn-param-store-all-delete: ## param store all delete
	make internal-cfn-delete STACK_NAME=$(PROJECT_PARAM_STORE_PROFILE)
	make internal-cfn-delete STACK_NAME=$(PROJECT_PARAM_STORE)

.PHONY: internal-cfn-deploy
internal-cfn-deploy: # [ args: STACK_NAME, CFN_PATH ]
	aws cloudformation deploy --capabilities CAPABILITY_NAMED_IAM \
	--template $(CFN_PATH) \
	--stack-name $(STACK_NAME) \
	--no-fail-on-empty-changeset \
	--parameter-overrides ProjectName=$(PROJECT_NAME) \
	--tags "Name=$(STACK_NAME)"


.PHONY: internal-cfn-delete #  [ args: STACK_NAME ]
internal-cfn-delete: # internal-cfn-delete
	aws cloudformation delete-stack --stack-name $(STACK_NAME)