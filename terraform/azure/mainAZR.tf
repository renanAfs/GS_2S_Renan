module "network" {
 source = "./modules/network"
}

module "compute" {
 source = "./modules/compute"
  rgname = module.network.rgname
  rglocation = module.network.rglocation
  vneta = module.network.vneta
  snvnetapub1a = module.network.snvnetapub1a
  snvnetapub1b = module.network.snvnetapub1b
}
