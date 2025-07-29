# S3 Bucket with CloudFront Terraform Module

This Terraform module creates an S3 bucket with CloudFront distribution for hosting static websites. It's designed to support multiple environments using variable files.

## 📁 Project Structure

```
s3-module-jabriuat/
├── README.md                 # This documentation file
├── main.tf                  # Main Terraform configuration
├── vars.tf                  # Variable declarations (no default values)
├── output.tf                # Output values after deployment
├── backend.tf               # Terraform state backend configuration
├── uatWebsite.tfvars       # Variables for uatwebsite.jabri.co environment
├── uatFront.tfvars         # Variables for uat.jabri.co environment
└── workspace.tfvars        # Template for new environments
```

## 🚀 Quick Start

### Prerequisites

1. **Terraform installed** (version 0.14+)
2. **AWS CLI configured** with appropriate credentials
3. **Proper IAM permissions** for S3, CloudFront, and IAM resources

### Step-by-Step Setup

#### 1. Create a New Workspace/Environment

```bash
# Clone or download this module
git clone <repository-url>
cd s3-module-jabriuat

# Initialize Terraform (first time only)
terraform init
```

#### 2. Create Your Environment Variables File

Create a new `.tfvars` file for your specific environment:

```bash
# Copy the template
cp workspace.tfvars my-new-environment.tfvars
```

Edit `my-new-environment.tfvars` with your values:

```hcl
aws_s3_bucket = "your-domain.com"

cloudfront_name = ["your-domain.com"]

commentofcloudfront = "CloudFront for your-domain.com"

tag_of_cloudfront = "your-domain.com"
```

#### 3. Update Backend Configuration (if needed)

Edit `backend.tf` if you need to change the Terraform state storage:

```hcl
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "your-project/terraform.tfstate"
    region = "your-region"
  }
}
```

#### 4. Plan and Apply

```bash
# Plan the deployment
terraform plan -var-file=my-new-environment.tfvars

# Apply the changes
terraform apply -var-file=my-new-environment.tfvars
```

## 📋 Detailed Instructions

### Understanding the Variables

| Variable | Type | Description | Example |
|----------|------|-------------|---------|
| `aws_s3_bucket` | string | S3 bucket name (usually your domain) | "mywebsite.com" |
| `cloudfront_name` | list(string) | CloudFront aliases/domains | ["mywebsite.com"] |
| `commentofcloudfront` | string | Description for CloudFront distribution | "My website CloudFront" |
| `tag_of_cloudfront` | string | Tag value for CloudFront resources | "mywebsite.com" |

### Creating Multiple Environments

1. **Development Environment:**
   ```bash
   # Create dev.tfvars
   aws_s3_bucket = "dev.mywebsite.com"
   cloudfront_name = ["dev.mywebsite.com"]
   commentofcloudfront = "Development environment"
   tag_of_cloudfront = "dev.mywebsite.com"
   ```

2. **Staging Environment:**
   ```bash
   # Create staging.tfvars
   aws_s3_bucket = "staging.mywebsite.com"
   cloudfront_name = ["staging.mywebsite.com"]
   commentofcloudfront = "Staging environment"
   tag_of_cloudfront = "staging.mywebsite.com"
   ```

3. **Production Environment:**
   ```bash
   # Create prod.tfvars
   aws_s3_bucket = "mywebsite.com"
   cloudfront_name = ["mywebsite.com", "www.mywebsite.com"]
   commentofcloudfront = "Production environment"
   tag_of_cloudfront = "mywebsite.com"
   ```

### Deployment Commands

```bash
# Initialize (first time only)
terraform init

# Format code
terraform fmt

# Validate configuration
terraform validate

# Plan deployment
terraform plan -var-file=YOUR_ENVIRONMENT.tfvars

# Apply changes
terraform apply -var-file=YOUR_ENVIRONMENT.tfvars

# Destroy resources (be careful!)
terraform destroy -var-file=YOUR_ENVIRONMENT.tfvars
```

### Available Outputs

After successful deployment, you'll get these outputs:

- `cdnarn` - CloudFront distribution ARN
- `cdndname` - CloudFront domain name
- `cloudfront_aliases` - CloudFront aliases
- `aws_s3_bucket` - S3 bucket domain name
- `distribution_domain_name` - CloudFront distribution domain

## 🔧 Customization

### Adding New Variables

1. **Add to `vars.tf`:**
   ```hcl
   variable "new_variable" {
     description = "Description of new variable"
     type        = string
   }
   ```

2. **Add to all `.tfvars` files:**
   ```hcl
   new_variable = "your_value"
   ```

3. **Use in `main.tf`:**
   ```hcl
   # Reference with var.new_variable
   ```

### Modifying Backend State

To use a different backend (e.g., different S3 bucket), update `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "s3-cloudfront/terraform.tfstate"
    region = "us-east-1"
    # Add encryption if needed
    encrypt = true
  }
}
```

## 🎯 Best Practices

### 1. Environment Management
- Always use descriptive names for `.tfvars` files
- Keep separate variable files for each environment
- Never commit sensitive values to version control

### 2. State Management
- Use remote state (S3 backend) for team collaboration
- Enable state locking with DynamoDB
- Regular state backups

### 3. Security
- Use IAM roles with minimal required permissions
- Enable S3 bucket encryption
- Configure CloudFront with proper security headers

### 4. Naming Conventions
```bash
# Environment files
dev.tfvars
staging.tfvars
prod.tfvars

# Or project-specific
myproject-dev.tfvars
myproject-prod.tfvars
```

## 🚨 Troubleshooting

### Common Issues

1. **Variable declaration errors:**
   ```bash
   Error: Variable declaration in .tfvars file
   ```
   **Solution:** Ensure `.tfvars` files contain assignments (`var = value`), not declarations.

2. **Missing required variables:**
   ```bash
   Error: No value for required variable
   ```
   **Solution:** Check that all variables in `vars.tf` have values in your `.tfvars` file.

3. **Backend initialization errors:**
   ```bash
   Error: Backend configuration changed
   ```
   **Solution:** Run `terraform init -reconfigure`

4. **Permission errors:**
   ```bash
   Error: AccessDenied
   ```
   **Solution:** Check AWS credentials and IAM permissions.

### Useful Commands

```bash
# Show current state
terraform show

# List resources
terraform state list

# Get specific output
terraform output cdndname

# Refresh state
terraform refresh -var-file=YOUR_ENVIRONMENT.tfvars

# Import existing resources
terraform import aws_s3_bucket.example bucket-name
```

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)

## 🔄 Workflow Summary

1. **Setup:** Clone repo → Initialize Terraform
2. **Configure:** Create/edit `.tfvars` file → Update `backend.tf` if needed
3. **Deploy:** Run `terraform plan` → Review changes → Run `terraform apply`
4. **Manage:** Use outputs for DNS/domain configuration
5. **Cleanup:** Use `terraform destroy` when no longer needed

## 📞 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Terraform and AWS documentation
3. Validate your `.tfvars` file format
4. Ensure proper AWS credentials and permissions

---

**Remember:** Always run `terraform plan` before `terraform apply` to review changes, and always specify the correct `-var-file` for your target environment! 