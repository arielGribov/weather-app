resource "aws_ecrpublic_repository" "weather_repo" {
  provider = aws.us_east_1

  for_each        = toset(local.ecr_repositories)
  repository_name = each.key
  # repository_name = "weather-repository"

  catalog_data {
    architectures     = ["x86"]
    operating_systems = ["Linux"]
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

# You're using aws_ecrpublic_repository, which is for public repositories only, but there's no indication public access is needed.
# lets change this to private repo
