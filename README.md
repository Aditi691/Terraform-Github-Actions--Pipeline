# Terraform CI/CD Pipeline with AWS

This project provisions a simple AWS infrastructure using Terraform and automates deployment through GitHub Actions. It creates a VPC, subnet, security group, EC2 instance, IAM role/profile, and remote state storage in S3. GitHub Actions is configured to authenticate to AWS using OpenID Connect (OIDC), allowing secure Terraform deployments without long-lived AWS credentials.

## Overview

The repository combines:

- Terraform infrastructure as code
- Remote state storage in Amazon S3
- EC2 provisioning with NGINX installed via user data
- GitHub Actions-based CI/CD workflow
- AWS IAM integration for GitHub OIDC authentication

## Architecture

The project provisions the following AWS resources:

- VPC with a public subnet
- Internet gateway and route table
- Security group exposing HTTP access
- EC2 instance running Ubuntu
- IAM role/profile for SSM access
- S3 bucket used for Terraform backend storage
- GitHub Actions IAM role using OIDC federation

The EC2 instance installs and runs NGINX using a cloud-init style user script (`userdata.sh`), and serves a simple HTML page showing the instance ID and a welcome message.

## Repository Structure

- `provider.tf` – AWS provider configuration
- `backend.tf` – remote Terraform state backend configuration
- `service.tf` – VPC, subnet, gateway, security group, EC2 instance, and S3 bucket definitions
- `iam.tf` – EC2 SSM role and instance profile
- `iam-github.tf` – GitHub OIDC provider and GitHub Actions deployment role
- `output.tf` – output values for the GitHub deployment role ARN
- `userdata.sh` – bootstrap script for the EC2 instance
- `.github/workflows/terraform-ci.yaml` – CI validation workflow
- `.github/workflows/deploy-cd.yaml` – deployment workflow

## Prerequisites

Before running this project, ensure you have:

- Terraform installed locally
- An AWS account with permissions to create IAM, EC2, VPC, and S3 resources
- AWS CLI configured or environment variables set for your account
- A GitHub repository connected to this codebase
- A GitHub Actions OIDC trust configured for the AWS role

## Terraform Setup

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the execution plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. Destroy resources when no longer needed:
   ```bash
   terraform destroy
   ```

## AWS Backend Configuration

The backend is configured in `backend.tf`:

- S3 bucket: `gitactions-demo-15`
- Terraform state key: `terraform-cicd/terraform.tfstate`
- AWS region: `us-east-1`
- Encryption enabled

This allows the Terraform state to be stored remotely and shared across environments or deployment workflows.

## GitHub Actions CI/CD

The repository contains two workflows:

### 1. Terraform CI
File: `.github/workflows/terraform-ci.yaml`

This workflow runs on push and pull request to `main` and performs:

- Terraform formatting check
- Terraform initialization without backend
- Terraform validation
- Static security scanning with Checkov

### 2. Terraform CD
File: `.github/workflows/deploy-cd.yaml`

This workflow runs on push to `main` and performs:

- AWS authentication using OIDC
- Terraform init
- Terraform plan
- Terraform apply

This is a secure deployment pattern because AWS credentials are not stored as long-lived secrets in GitHub.

## IAM and Security Notes

The project includes:

- An EC2 role for AWS Systems Manager (SSM)
- An OIDC provider for `token.actions.githubusercontent.com`
- A GitHub Actions IAM role with a trust policy scoped to the specific repository and branch

The deployment role is restricted using the `sub` claim in the OIDC trust policy to support least-privilege access. In the current configuration, it is scoped to a specific repository and branch reference.


