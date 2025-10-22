resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "4.11.2"

  values = [jsonencode({
    controller = {
      service = {
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb" 
        }
        targetPorts = {
          http  = "http"
          https = "http"
        }
      }
      publishService = {
        enabled = true
      }
    }
  })]

  depends_on = [module.eks]
}
