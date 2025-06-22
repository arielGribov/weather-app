
# You're using aws_ecrpublic_repository, which is for public repositories only, but there's no indication public access is needed.
# lets change this to private repo
##done

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

locals {
  ecr_repositories = [
    "weather-repo-backend-api",
    "weather-repo-frontend-app",
  ]
}
