# tf_codebuild_runner
Sample repo to demonstrate use of GH runner in CodeBuild and automated plan and apply actions.

# Installation

## Create the foundation of your own project

* Clone the repository to your own machine. (`git clone https://github.com/michthom/tf_codebuild_runner.git my_cool_project`)
* Remove the .git folder completely (`rm rf ./MY_COOL_PROJECT/.git`)
* Set up your own local repository
  * `cd ./MY_COOL_PROJECT/`
  * `git init -b main`
  * `git add .`
  * `git commit -m "Initial commit of MY_COOL_PROJECT"`
  * `git remote add origin https://github.com/ORGANISATION/MY_COOL_PROJECT.git`

* Create an empty repository under yoru organisation on GitHub
  * Set the repository name as given above e.g. MY_COOL_PROJECT
  * Do NOT add a README, .gitignore or license

* Push the code up to the new GitHub repository
  * `git push -u origin main`


## Create remote Terraform state backends

Switch to the account and region you want to use for the state buckets. The templates assume that the state bucket is in the same account as the corresponding
deployed environment.

This could be a separate account to the deployed environments, but if you do that you'll need to ensure the cross-account permissions are added to allow
the [`dev|stg|prd`] accounts to write to their respective state buckets. 

### S3 buckets

* Use CloudFormation to deploy the stack template [00_create_tf_state_buckets.yaml](./source/cloudformation/bootstrap/00_create_tf_state_buckets.yaml)
  for each of the `dev`, `stg` and `prd` environments.

* Verify the stacks deployed as expected and created the Parameter Store entries in whose values you will find the new bucket names:
  * `/${AWS::AccountId}/tf_state_bucket/dev`
  * `/${AWS::AccountId}/tf_state_bucket/stg`
  * `/${AWS::AccountId}/tf_state_bucket/prd`


## GitHub OIDC Identity Provider
  
For each of the unique accounts hosting any of the `dev`, `stg` and `prd` environments (e.g. if all envirionments are in one account you only need to do this once)
* Switch to the account and region you set up.
* Use CloudFormation to deploy the stack template [05_create_GitHub_OIDC.yaml](./source/cloudformation/bootstrap/05_create_GitHub_OIDC.yaml)

* Verify the stacks deployed as expected and created the Parameter Store entries in whose values you will find the new provider ARN, and audience:
  * `/${AWS::AccountId}/github-oidc-provider/arn`
  * `/${AWS::AccountId}/github-oidc-provider/audience`


## Terraform deployment roles

* Use CloudFormation to deploy the stack template [10_create_tf_deploy_role.yaml](./source/cloudformation/bootstrap/10_create_tf_deploy_role.yaml)

* Verify the stacks deployed as expected and created the Parameter Store entries in whose values you will find the new role ARNs:
  * `/${AWS::AccountId}/tf_deployment_role_arn/dev`
  * `/${AWS::AccountId}/tf_deployment_role_arn/stg`
  * `/${AWS::AccountId}/tf_deployment_role_arn/prd`


## Configure the GitHub elements of the project

### Repository-level changes

* In Settings / Secrets and variables / Actions
  * Go to the Variables tab and create

    | Parameter | Value |
    |-----------|-------|
    | PROJECT_NAME | MY_COOL_PROJECT |

  Accessible as `${{ vars.PROJECT_NAME }}` for example.

Reference: [Github link](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-variables#creating-configuration-variables-for-a-repository)

### Environment-level changes

* In Settings/Environments
  * Create each of the `dev`, `stg` and `prd` environments.
* In `Settings / Environments`
  for each environment in `dev`, `stg` and `prd`
  * Configure the following variables for each environment:

  | Variable  | dev | stg | prd |
  |-----------|-----|-----|-----|
  | AWS_ACCOUNT_NUMBER | 184161904230 | 367560037806 | 681574184492 |
  | AWS_REGION | eu-west-2 | eu-west-2 | eu-west-2 |
  | TF_DEPLOY_ROLE_ARN | Obtained from steps above | Obtained from steps above | Obtained from steps above |
  | TF_STATE_BUCKET | Obtained from steps above | Obtained from steps above | Obtained from steps above |
  | TF_STATE_BUCKET_REGION | eu-west-2 | eu-west-2 | eu-west-2 |

  Accessible as `${{ vars.ENVIRONMENT }}`

  Reference: [Github link](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-variables#creating-configuration-variables-for-an-environment)

## Set up GitHub Runner project in CodeBuild

 * [Tutorial](https://docs.aws.amazon.com/codebuild/latest/userguide/action-runner.html)

 * Needs an active GitHub App token for authentication

 * Needs the AWS Connector for GitHub installed as an application in GitHub - listing each repo that can be used (or all in organisation)

 * Needs a service role that CodeBuild can assume, which in turn allowes it to assume GitHub's OIDC-authenticated identity 
 * Needs a VPC, at least a public subnet with NAT Gateway and Internet Gateway and a private subnet with route to the NAT gateway for 0.0.0.0/0
 * Needs CloudWatch log group
 
 * ${AWS::AccountId}-github-runner-${ENDVIRONMENT}
 * 

Can we adapt the [sample from AWS](https://github.com/aws-samples/sample-aws-security-incident-response-integrations/blob/main/codebuild-facility.yaml)?