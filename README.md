# terraform-practice

Infrastructure as Code(IaC) Tool 인 Terraform 을 이용해 AWS Cloud 에 Infrastructure 를 구성해보는 실습입니다.
Terraform 기초개념 학습 및 실습, Terraform 의 AWS Provider 사용 실습을 목표로 하였습니다.

## Concepts

### Terraform

#### CLI Commands



- <https://developer.hashicorp.com/terraform/tutorials/cli>

#### Hashicorp Configuration Language(HCL)

#### Providers

##### Resources

##### Data Resources

#### State

#### Terraform Cloud

## Implementations

### Terraform State In Local

#### Terraform Init

#### `main.tf` 파일 작성

#### `main.tf` 파일 Validation

#### AWS Shared Credential 설정

#### Terraform Plan

#### Terraform Apply

### Terraform State In Cloud

#### Terraform Cloud 계정 생성

#### `main.tf` 수정

#### AWS Account 에 Terraform OpenID Connect integration(OIDC) 연결

##### AWS Account 에 Terraform OIDC Identity Provider 추가

##### Terraform OIDC Identity Provider 용 Trust Policy Role 추가

##### Terraform Cloud 에 허용할 Policy 및 AssumeRole 추가

#### Terraform Cloud 설정 변경

##### Terraform Cloud Workspace 에 AWS OIDC 관련 ENV 변수 추가

#### Terraform Validate

#### Terraform Plan

#### Terraform Apply

## Conclusion

## References

- <https://registry.terraform.io/providers/hashicorp/aws/latest/docs>
- <https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration>