locals {
  name                 = "aws-load-balancer-controller"
  service_account_name = "${local.name}-sa"

  default_helm_config = {
    name        = local.name
    chart       = local.name
    repository  = "https://aws.github.io/eks-charts"
    version     = "1.3.1"
    namespace   = "kube-system"
    timeout     = "1200"
    values      = local.default_helm_values
    description = "aws-load-balancer-controller Helm Chart for ingress resources"
  }

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )

  default_helm_values = [templatefile("${path.module}/values.yaml", {
    aws_region           = var.addon_context.aws_region_name,
    eks_cluster_id       = var.addon_context.eks_cluster_id,
    service_account_name = local.service_account_name,
    ecr_registry_prefix  = local.ecr_registry_prefix[var.addon_context.aws_region_name]
  })]

  set_values = [
    {
      name  = "serviceAccount.name"
      value = local.service_account_name
    },
    {
      name  = "serviceAccount.create"
      value = false
    }
  ]

  argocd_gitops_config = {
    enable             = true
    serviceAccountName = local.service_account_name
  }

  irsa_config = {
    kubernetes_namespace              = "kube-system"
    kubernetes_service_account        = local.service_account_name
    create_kubernetes_namespace       = false
    create_kubernetes_service_account = true
    iam_role_path                     = "/"
    irsa_iam_policies                 = [aws_iam_policy.aws_load_balancer_controller.arn]
    irsa_iam_permissions_boundary     = var.irsa_iam_permissions_boundary
  }

  # each region pulls container images from its own registry 
  # for more information see: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  ecr_registry_prefix = {
    af-south-1 = 877085696533,
    ap-east-1 = 800184023465,
    ap-northeast-1 = 602401143452,
    ap-northeast-2 = 602401143452,
    ap-northeast-3 = 602401143452,
    ap-south-1 = 602401143452,
    ap-southeast-1 = 602401143452,
    ap-southeast-2 = 602401143452,
    ca-central-1 = 602401143452,
    cn-north-1 = 918309763551,
    cn-northwest-1 = 961992271922,
    eu-central-1 = 602401143452,
    eu-north-1 = 602401143452,
    eu-south-1 = 590381155156,
    eu-west-1 = 602401143452,
    eu-west-2 = 602401143452,
    eu-west-3 = 602401143452,
    me-south-1 = 558608220178,
    sa-east-1 = 602401143452,
    us-east-1 = 602401143452,
    us-east-2 = 602401143452,
    us-gov-east-1 = 151742754352,
    us-gov-west-1 = 013241004608,
    us-west-1 = 602401143452,
    us-west-2 = 602401143452 
  }
}
