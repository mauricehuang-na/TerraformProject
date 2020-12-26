# TerraformProject

### Setting Credentials for Azure provider
 # Prerequisites
 * Must have Azure CLI downloaded
 * Run Login command (az login)
 * Must have terraform CLI


### Run Terraform CLI commands

To initialize:
$terraform init

To plan
$terraform plan

To Apply
$terraform apply

To Destroy
$terraform destroy

### Having Trouble Pushing To Github due to Credential issues?

# Ensure that git source is ssh, and not https:
run $git remote get-url origin

ensure that output is "git@github.com:mauricehuang-na/TerraformProject.git". If not, run this command to change source from https to ssh

$git remote set-url origin git@github.com:mauricehuang-na/TerraformProject.git

# From SourceTree
Tools -> Option -> General -> (Under SSH Client Configuration) enable the following configuration:
SSH Key: "C:\Users\{user}\.ssh\id_rsa"
SSH Client: OpenSSH