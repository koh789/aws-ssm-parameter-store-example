PROJECT_NAME_CROSS_REFERENCE=dummy-cross-reference-paramter-project
PROJECT_NAME_CROSS_REFERENCE_PROFILE=$(PROJECT_NAME_CROSS_REFERENCE)-instance-profile
PROJECT_NAME_SSM=dummy-ssm-paramter-project
PROJECT_NAME_SSM_PROFILE=$(PROJECT_NAME_SSM)-instance-profile

.PHONY: help
help: ## help 表示 `make help` でタスクの一覧を確認できます
	@echo "------- タスク一覧 ------"
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36mmake %-20s\033[0m %s\n", $$1, $$2}'


.PHONY: cfn-example-cross-reference-instance-profile-deploy
cfn-example-cross-reference-instance-profile-deploy: ## cfn-example-cross-reference-instance-profile-deploy
	make internal-cfn-deploy CFN_PATH=deployments/cfn/example2/instance-profile.yml STACK_NAME=$(PROJECT_NAME_CROSS_REFERENCE_PROFILE)

.PHONY: cfn-example-cross-reference-deploy
cfn-example-cross-reference-deploy: ## cfn-example-cross-reference-deploy
	make internal-cfn-deploy CFN_PATH=deployments/cfn/example2/template.yml STACK_NAME=$(PROJECT_NAME_CROSS_REFERENCE)

.PHONY: cfn-example-cross-reference-all-delete
cfn-example-cross-reference-all-delete: ## cfn-example-cross-reference-all-delete
	make internal-cfn-delete STACK_NAME=$(PROJECT_NAME_CROSS_REFERENCE_PROFILE)
	make internal-cfn-delete STACK_NAME=$(PROJECT_NAME_CROSS_REFERENCE)

.PHONY: cfn-example-ssm-instance-profile-deploy
cfn-example-ssm-instance-profile-deploy: ## cfn-example-ssm-instance-profile-deploy
	make internal-cfn-deploy CFN_PATH=deployments/cfn/example2/instance-profile.yml STACK_NAME=$(PROJECT_NAME_SSM_PROFILE)

.PHONY: cfn-example-ssm-deploy
cfn-example-ssm-deploy: ## cfn-example-ssm-deploy
	make internal-cfn-deploy CFN_PATH=deployments/cfn/example2/template.yml STACK_NAME=$(PROJECT_NAME_SSM)

.PHONY: cfn-example-ssm-all-delete
cfn-example-ssm-all-delete: ## cfn-example-ssm-all-delete
	make internal-cfn-delete STACK_NAME=$(PROJECT_NAME_SSM_PROFILE)
	make internal-cfn-delete STACK_NAME=$(PROJECT_NAME_SSM)

.PHONY: internal-cfn-deploy
internal-cfn-deploy: # [ args: STACK_NAME, CFN_PATH ]
	aws cloudformation deploy --capabilities CAPABILITY_NAMED_IAM \
	--template $(CFN_PATH) \
	--stack-name $(STACK_NAME) \
	--no-fail-on-empty-changeset \
	--tags "Name=$(STACK_NAME)"

.PHONY: internal-cfn-delete #  [ args: STACK_NAME ]
	aws cloudformation delete-stack --stack-name $(STACK_NAME)