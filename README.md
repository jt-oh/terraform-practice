# terraform-practice

Infrastructure as Code(IaC) Tool 인 Terraform 을 이용해 AWS Cloud 에 Infrastructure 를 구성해보는 실습입니다.
Terraform 기초개념 학습 및 실습, Terraform 의 AWS Provider 사용 실습을 목표로 하였습니다.

## Concepts

### Terraform

<https://developer.hashicorp.com/terraform/intro>

Terraform 은 on-premise, 클라우드 자원을 Code 수준으로 정의하여 자원의 LifeCycle 을 관리할 수 있도록 하는 Infrasture as Code Tool 입니다.
Terraform 을 이용하면 Cloud Provider 에 관계없이 Compute, Storage, Network Resource 를 관리/추적할 수 있습니다.
또한, Resource 관리 작업을 효율적으로 만들어줍니다.

#### CLI Commands

<https://developer.hashicorp.com/terraform/tutorials/cli>

##### Terraform Init

``` bash
terrafrom init
```

현재 Directory 에 terraform 명령어 실행 환경을 설정합니다.
설정되는 환경은 다음과 같습니다.

1. Terraform downloads the modules referenced in the configuration.
2. Terraform initializes the backend(State 를 저장할 위치).
3. Terraform downloads the providers referenced in the configuration.
4. Terraform creates a lock file, which records the versions and hashes of the providers used in this run.

`terraform init` 명령어는 Terraform 첫 설정 시에 반드시 실행되어야 합니다.
또한, Terraform Configuration 의 Provider 버전, Module 버전, Backend 가 변경되는 경우 `terrafrom init` 으로 Terraform 환경 재설정이 필요합니다.

##### Terraform Validate

``` bash
terraform validate
```

Terraform 설정(Provider, Module, Resource)이 올바른지 확인합니다.
Terraform 설정 파일 변경 후, `terraform plan` 혹은 `terraform apply` 전 사용합니다.

##### Terraform Plan

``` bash
terraform plan
```

Terraform 설정으로 생성되는 Resources, Data Resources 계획을 출력합니다.
해당 명령어로 실제 Resources 가 생성되지 않습니다.

Terraform 설정에 따라 `terraform plan` 명령이 실행되는 위치를 변경할 수 있습니다.

##### Terraform Apply

``` bash
terraform apply
```

Terraform 설정으로 생성되는 Resources 및 Data Resources 계획을 실제로 생성합니다.
생성된 Resources 및 Data Resources 를 backend 의 state 파일에 저장합니다.

Terraform 설정에 따라 `terraform apply` 명령이 실행되는 위치 및 state 가 저장되는 backend 를 변경할 수 있습니다.

##### Terraform Destroy

``` bash
terraform destroy
```

Terraform 설정으로 생성된 Resources 를 제거합니다.

#### Hashicorp Configuration Language(HCL)

Terraform 설정을 기술하는 언어입니다.
Terraform 설정 파일의 버전, backend 설정, Provider 선언, Module 사용 및 Resources 를 정의하는데 사용됩니다.
`main.tf` 파일이 최초 진입점입니다.

##### Providers

<https://developer.hashicorp.com/terraform/language/providers>

Provider 는 AWS, Google Cloud Provider 와 같은 Cloud Provider, SaaS Provider 혹은 다른 API 와 Interact 하는 기능을 가진 플러그인입니다.
사용하려는 Provider 는 각 Provider 마다 요구하는 정보을 이용해 Terraform 설정에 설정되어 Terraform Init 에 의해 설치된 후 사용됩니다.
Provider 는 각 Provider 가 제공하는 자원 (Resources, Data Resrouces) 을 Terraform 설정에서 관리하는 방법을 제공합니다.
각 Provider 가 제공하는 자원의 사용방법은 [Provider Registry](https://registry.terraform.io/browse/providers) 에서 확인할 수 있습니다.

#### State

<https://developer.hashicorp.com/terraform/language/state>

Terraform 설정으로 생성된 Resource 는 관리를 위해 Resource 의 정보를 Terraform 에 기록해두어야 합니다.
이 정보들이 기록된 파일이 State 파일로, Terraform 설정의 backend 에 따라 State 파일의 저장 위치가 결정됩니다.
기본값은 local 로 State 정보가 Terraform Root Directory 에 `terrafrom.tfstate` 파일에 저장됩니다.
backend 로는 Terraform Cloud, AWS S3 등과 같이 팀원과 공유 가능한 외부 저장소를 사용할 수도 있습니다.
사용 가능한 backend 목록은 [Terraform Docs](https://developer.hashicorp.com/terraform/language/settings/backends/configuration) 에서 확인할 수 있습니다.

## Implementations

### Terraform State In Local

#### Terraform Init

``` bash
// ~/terraform-test

$ terraform init
```

#### `main.tf` 파일 작성

AWS EC2 Intstance 를 생성하는 Terraform 설정입니다.
AWS Credential 은 AWS CLI 의 shared configuration file 을 사용하였습니다.

AWS Credential 로 사용되는 위치의 우선순위는 다음 [AWS Provider Doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) 에서 확인할 수 있습니다.

``` terraform
// ~/terraform-test/main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "aws_instance_test" {
  ami           = data.aws_ami.amazon_linux_2_ami.image_id
  instance_type = "t2.micro"
  tags = {
    Name = "terraform_created_instance"
  }
}

data "aws_ami" "amazon_linux_2_ami" {
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20230221.0-x86_64-gp2"]
  }
}
```

#### `main.tf` 파일 Validation

`terraform fmt` 를 이용해 Terraform 설정의 Syntex 를 수정합니다.
`terraform validate` 을 이용해 Terrform 에서 사용된 Provider Resource 요소가 적절히 설정되었는지 확인합니다.

``` bash
// ~/terraform-test

$ terraform fmt
$ terraform validate
```

#### Terraform Plan

`terraform plan` 을 이용해 작성한 Terraform 설정이 생성할 Resource 계획을 확인합니다.
해당 명령어로는 실제 Resource 가 생성되지는 않습니다.

``` bash
// ~/terraform-test

$ terraform plan
```

#### Terraform Apply

`terraform apply` 을 이용해 작성한 Terraform 설정으로 Resource 를 생성합니다.
생성된 Resource 정보는 State 파일에 저장되어 Resource 에 대한 관리가 이루어집니다.

``` bash
// ~/terraform-test

$ terraform apply
```

### Terraform State In Cloud

Remote Backend 에 Terraform State 를 저장하도록 변경합니다.
Remote Backend 로는 Terraform Cloud 를 선택하였습니다.

Remote Backend 를 Terraform Cloud 로 설정할 경우, Terraform Plan/Apply 와 같은 명령어는 Terraform Cloud 의 Runner 에서 실행됩니다.
Terraform Cloud Runner 에는 설정된 AWS Credential 이 없으므로 AWS Resource 정보 접근을 위한 API 가 실패합니다.

AWS Credential 을 전달하는 방법으로 Terraform 설정에 Hard Coding 하는 방법, Terraform Cloud Runner 에 AWS Role 을 부여하는 방법이 있습니다.
이 중 Hard Coding 하는 방법은 AWS Credential 이 유출되므로 저는 후자를 선택하여 AWS Resource 접근 권한을 Terraform Cloud Runner 에 부여했습니다.

#### Terraform Cloud 계정 생성

Terraform Cloud 계정을 생성합니다.

#### Terraform Cloud Runner 에 AWS Role 부여

Terraform Cloud 에 Temporal AWS Credential 을 제공할 수 있는 AWS Role 을 부여하는 방법은 다음과 같습니다.

1. AWS Account 에 Terraform OIDC Identity Provider 추가
2. Terraform OIDC Identity Provider 용 Trust Policy Role 추가
3. Terraform Cloud 에 허용할 Policy 및 AssumeRole 추가
4. Terraform Cloud Workspace 에 AWS OIDC 관련 ENV 변수 추가

자세한 설정 방법은 [Terraform Doc](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration#create-an-oidc-identity-provider) 에 설명되어 있습니다.

#### `main.tf` 수정

``` terraform
// ~/terraform-test/main.tf
terraform {
  cloud {
    organization = "jtoh0227"
    workspaces {
      name = "cloud-workspace-test"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "aws_instance_test" {
  ami           = data.aws_ami.amazon_linux_2_ami.image_id
  instance_type = "t2.micro"
  tags = {
    Name = "terraform_created_instance"
  }
}

data "aws_ami" "amazon_linux_2_ami" {
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20230221.0-x86_64-gp2"]
  }
}
```

#### Terraform Login

Terraform Cloud 에 Authenticate 합니다.
Authenticate 되면 Credential 이 Local 에 저장됩니다.

<https://developer.hashicorp.com/terraform/tutorials/cli/cloud-login>

``` bash
// ~/terraform-test

$ terraform login
```

#### Terraform Init

Terraform 설정의 Backend 가 변경되었으므로 반드시 재 Initialize 를 해주어야 합니다.

``` bash
// ~/terraform-test

$ terraform init
```

#### Terraform Validate

Terraform Validate 은 Backend 를 Local 로 설정하였을 때와 동일합니다.

#### Terraform Plan

Terraform Backend 를 Terraform Cloud 로 설정하였기 때문에 Terraform Plan 이 Terraform Cloud Runner 애서 실행됩니다.
명령어가 AWS Credential 오류 없이 정상적으로 실행되었다면 'Terraform Cloud Runner 에 AWS Role 부여' 가 잘 설정된 것입니다.

#### Terraform Apply

Terraform Plan 과 마찬가지로 Terraform Apply 도 Terraform Cloud Runner 에서 실행됩니다.
정상적으로 실행되었다면 State 파일은 Backend 를 Local 로 설정했을 때와는 다르게 Terraform Cloud Runner 에 저장됩니다.
State 파일은 Terraform 설정에 설정한 Terraform Cloud 의 Workspace 에서 확인할 수 있습니다.

``` bash
// ~/terraform-test

$ terraform plan
```

## Conclusion

본 실습에서는 Terraform 에 대한 이해 및 실습과 Terraform 을 이용한 AWS Infra 구축 실습을 하였습니다.

처음에는 Terraform 을 Local 에서 실행하고 구현한 Terraform 설정을 버전관리 하는 것까지를 목표로 하였습니다.
Terraform 설정 버전관리는 여러 PC 에서 git 저장소를 이용해 Terraform 으로 생성된 인프라를 관리하고자 함을 목적으로 하였는데,
이는 Local 에 State 를 저장하는 방법으로는 실행 불가능하였습니다.
따라서 State 를 외부(Terraform Cloud)로 옮겼습니다.
이 과정에서 Terraform Plan/Apply 명령어가 Terraform Cloud Runner 에서 실행되게 되어 local 에 설정되어 있는 AWS Credential 을 사용할 수 없어 AWS Resource 에 접근하지 못하는 문제가 발생하였습니다.
이를 해결하기 위해서 Terraform Cloud 에 AWS Role 을 부여하는 작업을 진행하여 Terraform Plan/Apply 명령어가 AWS Resource 를 관리할 수 있도록 하였습니다.

나중에 Terraform Cloud 의 설정을 더 찾아보니, Terraform Plan, Apply 와 같은 명령어는 local 에서 실행할 수 있는 설정이 있는 것을 알게 되었습니다.
위 설정을 사용하면 Terraform Cloud Runner 에 AWS Role 을 부여할 필요 없이 Local 에 있는 AWS Credential 을 이용해 Resource 관리를 할 수 있습니다.

## References

- <https://developer.hashicorp.com/terraform>
- <https://registry.terraform.io/providers/hashicorp/aws/latest/docs>
- <https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html>
- <https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration>