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


## Create Terraform state buckets in your account/region

* Switch to the account and region to want to use for the state buckets
* Use CloudFormation to deploy the stack template [00_create_tf_state_buckets.yaml](./source/cloudformation/bootstrap/00_create_tf_state_buckets.yaml)
  for each of the `dev`, `stg` and `prd` environments.
* Verify the stacks deployed as expected and created the Parameter Store entries in whose values you will find the new bucket names:
  * `/{AWS::AccountId}/tf_state_bucket/dev`
  * `/{AWS::AccountId}/tf_state_bucket/stg`
  * `/{AWS::AccountId}/tf_state_bucket/prd`


## Create Terraform deployment role per environment

* Switch to the account and region to want to use for the state buckets
* Use CloudFormation to deploy the stack template [10_create_tf_deploy_role.yaml](./source/cloudformation/bootstrap/10_create_tf_deploy_role.yaml)
  for each of the `dev`, `stg` and `prd` environments.


## Configure the GitHub elements of the project

* In Settings / Secrets and variables / Actions
  * Go to the Variables tab and create

    | Parameter | Value |
    |-----------|-------|
    | PROJECT_NAME | MY_COOL_PROJECT |

  Accessible as `${{ vars.PROJECT_NAME }}` for example.

Reference: [Github link](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-variables#creating-configuration-variables-for-a-repository)


* In Settings/Environments
  * Create each of the `dev`, `stg` and `prd` environments.
* In `Settings / Environments`
  for each environment in `dev`, `stg` and `prd`
  * Configure the following variables for each environment:

  | Variable  | dev | stg | prd |
  |-----------|-----|-----|-----|
  | AWS_ACCOUNT_NUMBER | Your chosen account | Your chosen account | Your chosen account |
  | AWS_REGION | Your chosen account | Your chosen account | Your chosen account |
  | TF_DEPLOY_ROLE_ARN | Obtained from steps above | Obtained from steps above | Obtained from steps above |
  | TF_STATE_BUCKET | Obtained from steps above | Obtained from steps above | Obtained from steps above |
  | TF_STATE_BUCKET_REGION | Your chosen region | Your chosen region | Your chosen region |

  Accessible as `${{ vars.ENVIRONMENT }}`

  Reference: [Github link](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-variables#creating-configuration-variables-for-an-environment)

* GitHub Runner configuration
  
  TBC
