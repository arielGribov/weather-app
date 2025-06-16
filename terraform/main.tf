# Everything is in a flat structure — EKS, VPC, ECR, and Kubernetes configs are managed together.
# modules/
# ├── vpc/
# ├── eks/
# ├── ecr/
# ├── alb/
# ├── security_groups/


# Hardcoded subnet CIDRs, security group names, and region references (us-east-1) are scattered throughout.
# Use variables and locals for defaults
# Use workspaces or TF_VAR_environment to define per-env values


# Add Automated Validation - terraform validate
