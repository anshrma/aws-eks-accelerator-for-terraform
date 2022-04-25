locals {
  name                 = "csi-secrets-store-provider-aws"

  default_helm_config = {
    name        = local.name
    chart       = local.name
    repository  = "https://aws.github.io/eks-charts"
    version     = "0.0.2"
    namespace   = local.name
    description = "A Helm chart to install the Secrets Store CSI Driver and the AWS Key Management Service Provider inside a Kubernetes cluster."
    values      = local.default_helm_values
    timeout     = "1200"
  }

  default_helm_values = []

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )

  set_values = [
    {
      name  = "secrets-store-csi-driver.install"
      value = "true"
    }
  ]

  argocd_gitops_config = {
    enable             = true
  }
}