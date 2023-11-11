# Using Terraform to Provision Infrastructure on AWS

This project involves using terraform to provision the following infrastructure on AWS:

- VPC
- Subnets attached to the vpc
- Route tables and internet gateways all connected
- EC2 instance provisioned to run an Nginx docker image

## Tools and Technologies

![terraform][terraform] ![aws][aws] ![docker][docker] ![nginx][nginx]

[terraform]: <https://img.shields.io/badge/terraform-844FBA?style=for-the-badge&labelColor=black&logo=terraform&logoColor=#844FBA>
[aws]: <https://img.shields.io/badge/amazonaws-232F3E?style=for-the-badge&labelColor=black&logo=amazonaws&logoColor=white>
[docker]: <https://img.shields.io/badge/docker-2496ED?style=for-the-badge&labelColor=black&logo=docker&logoColor=2496ED>
[nginx]: <https://img.shields.io/badge/nginx-009639?style=for-the-badge&labelColor=black&logo=nginx&logoColor=009639>

## Installations

1. Install terraform on Windows using chocolatey (https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

    - Do `terraform` to confirm installation

2. Configure aws on the terminal using `aws configure`

    - Do `aws configure list` to confirm

## Initialize

1. Create the terraform files in your working directory

    - main.tf
        - This is used to specify provider and define resources to be created or reference modules with defined resources
    
    - outputs.tf
        - This is used to request output from the terraform process
    
    - variables.tf
        - For defining variables
    
    - terraform.tfvars
        - For holding variables
    
    - variables.tf and terraform.tfvars are not pushed to public github repository because they contain sensitive information

2. Inside the working folder/directory in terminal, do `terraform init`

    - This creates a `.terraform` directory and a `.terraform.lock.hcl` file

## Provision Infrastructure

1. Do `terraform plan` to validate

2. Do `terraform apply -auto-approve` to create

    - This will create the resources on aws

    - It will also create a `terraform.tfstate` file in the working directory

3. Applying more resources or modifying will create a `terraform.tfstate.backup` file in the working directory to hold the previous state values

4. `terraform state list` will show all resources in that state

5. `terraform state show aws_vpc.terra_vpc`

    - This will show all the properties of the vpc named 'terra_vpc'

    - You can also find these in the tfstate file

6. To destroy all resources
    ```
    terraform destroy -auto-approve
    ```

## N.B.

### Workspaces

Workspaces isolate files and resources

- `terraform workspace show` to show current workspace

- `terraform worspace list` to see all workspaces

- `terraform workspace new name-of-new-workspace` to create a new workspace

- `terraform workspace select name-of-workspace` to switch between workspaces

- `terraform worspace delete name-of-workspace` to delete a workspace