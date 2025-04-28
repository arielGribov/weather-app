locals {
  public_and_private_subnets_ids = concat(module.vpc.private_subnets, module.vpc.public_subnets)
}