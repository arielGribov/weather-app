# resource "null_resource" "deploy_apps" {
#   depends_on = [module.eks, aws_ecrpublic_repository.weather_repo]

#   provisioner "local-exec" {
#     command = "bash ./deploy_apps.sh"
#   }
# }
