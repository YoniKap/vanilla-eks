module "jenkins" {
  source = "./modules"

  # optional vars if you want to parameterize
  namespace     = "jenkins"
  chart_version = "5.3.2"
}
