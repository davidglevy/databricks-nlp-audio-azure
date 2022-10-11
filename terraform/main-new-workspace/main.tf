
module "user-common" {
  source = "../modules/user-common"
  prefix = var.prefix
}

module "workspace" {
  source = "../modules/uc-workspace"
  region = var.region
  prefix = module.user-common.prefix
  owner-username = module.user-common.username
}

// TODO Add data-plane, repos and DLT.