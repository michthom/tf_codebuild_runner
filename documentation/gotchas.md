# Gotchas

To have a dynamic workflow that can call the correct self-hosted GitHub Runner in CodeBuild, regardless of the account that is hosting the
dev, stg or prd environments, we need to split the job in two, where an initial part runs on a **GitHub** hosted runner (not in CodeBuild).

That inital access requires the AWS account to have an OIDC IdP for GitHub:

[GitHub documentation](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws)

[AWS Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html)

| Parameter |  Value |
| --------- |  ----- |
| Provider URL | https://token.actions.githubusercontent.com |
| Audience | sts.amazonaws.com |

Thumbprint is NOT required - that's a fallback mechanism.



...and also a trust policy for the deployment account that links the GitHub repo.

N.B. the AWS documentation is misleading suggesting the `token.actions.githubusercontent.com:sub` should include `repo:GitHubOrg/GitHubRepo:ref:refs/heads/GitHubBranch` but experiment showed that GitHub sets this value to `repo:GitHubOrg/GitHubRepo:environment:xxx`

```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "AllowCodeBuildRunner",
			"Effect": "Allow",
			"Principal": {
				"Service": "codebuild.amazonaws.com"
			},
			"Action": "sts:AssumeRole",
			"Condition": {
				"StringEquals": {
					"aws:SourceAccount": "667532145122"
				}
			}
		},
		{
			"Sid": "AllowGitHubRunner",
			"Effect": "Allow",
			"Principal": {
				"Federated": "arn:aws:iam::667532145122:oidc-provider/token.actions.githubusercontent.com"
			},
			"Action": "sts:AssumeRoleWithWebIdentity",
			"Condition": {
				"StringEquals": {
					"token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
				},
				"ForAnyValue:StringEquals": {
					"token.actions.githubusercontent.com:sub": [
						"repo:michthom/tf_codebuild_runner:environment:dev",
						"repo:michthom/tf_codebuild_runner:environment:stg",
						"repo:michthom/tf_codebuild_runner:environment:prd"
					]
				}
			}
		}
	]
}
```
