module "jenkins" {
  source = "./modules/jenkins"

  # optional vars if you want to parameterize
  namespace     = "jenkins"

}
