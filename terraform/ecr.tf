# resource "aws_ecrpublic_repository" "weather_repo" {
#   provider = aws.us_east_1

#   for_each        = toset(local.ecr_repositories)
#   repository_name = each.key

#   catalog_data {
#     architectures     = ["x86"]
#     operating_systems = ["Linux"]
#   }
#   tags = {
#     Name = "Weathers_project"
#   }
# }
locals {
  ecr_repositories = [
    "weather-repo-backend-api",
    "weather-repo-frontend-app",
  ]
}

# You're using aws_ecrpublic_repository, which is for public repositories only, but there's no indication public access is needed.
# lets change this to private repo
# module "ecr" {
#   source = "terraform-aws-modules/ecr/aws"

#   for_each        = toset(local.ecr_repositories)
#   repository_name = each.key

#   repository_read_write_access_arns = ["arn:aws:iam::012345678901:role/terraform"]
#   repository_lifecycle_policy = jsonencode({
#     rules = [
#       {
#         rulePriority = 1,
#         description  = "Keep last 30 images",
#         selection = {
#           tagStatus     = "tagged",
#           tagPrefixList = ["v"],
#           countType     = "imageCountMoreThan",
#           countNumber   = 30
#         },
#         action = {
#           type = "expire"
#         }
#       }
#     ]
#   })

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

resource "aws_ecr_repository" "weather_repo" {
  for_each = toset(local.ecr_repositories)
  name     = each.key
  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = "Weathers_project"
  }
}