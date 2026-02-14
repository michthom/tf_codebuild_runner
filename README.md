# tf_codebuild_runner
Sample repo to demonstrate use of GH runner in CodeBuild and automated plan and apply actions.

# Components and configuration steps

## GitHub repository

### Global variables

Repository settings
 * Secrets and variables / Actions
 * Variables tab
 * New repository variable
 * Name: AWS_REGION, Value: eu-west-2

 Accessible as `${{ vars.AWS_REGION }}`

 Reference: [Github link](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-variables#defining-configuration-variables-for-multiple-workflows)


| Parameter | Value |
|-----------|-------|
| PROJECT_NAME | MyCoolProject |
| AWS_REGION | eu-west-2 |

### Environments and variables

Settings / Environments

Define an environment for dev, stg and prd

Link deployments to branches ? To be decided later

Add Environment variables for:

| Parameter | dev | stg | prd |
|-----------|-----|-----|-----|
| ENVIRONMENT | dev | stg | prd |
| AWS_ACCOUNT_NUMBER | 667532145122 | 667532145122 (for now) | 667532145122 (for now) |
| TF_DEPLOY_ROLE_ARN | arn:aws:iam::667532145122:role/667532145122-codebuild-github-runner | {Ditto for now} | {Ditto for now}
| TF_STATE_BUCKET | 667532145122-tf-state-dev-cbfe6a30 | 667532145122-tf-state-stg-08415b10 | 667532145122-tf-state-prd-243433b0 |
| TF_STATE_BUCKET_REGION | eu-west-1 | eu-west-1 | eu-west-1 |

 Accessible as `${{ vars.ENVIRONMENT }}`

  Reference: [Github link](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-variables#creating-configuration-variables-for-an-environment)

## AWS Account(s)
