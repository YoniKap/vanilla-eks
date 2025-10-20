resource "kubernetes_namespace" "env-namespace" {
  metadata {
    name = "${var.environment}"
  }
}

module "iam_assumable_role_apps" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 5.46.0"
  create_role                   = true
  role_name                     = "${var.environment}RoleForServiceAccount"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns = []
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.environment}:${local.service_account_name}"]
}

resource "kubernetes_service_account" "service-account" {
  metadata {
    name      = local.service_account_name
    namespace = "${var.environment}"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_apps.iam_role_arn
    }
  }
}


resource "aws_iam_policy" "app_policy" {
  name        = "${var.environment}-bucket-access"
  path        = "/"
  description = "${local.service_account_suffix} AWS services access policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${module.s3_bucket.s3_bucket_id}",
          "arn:aws:s3:::${module.s3_bucket.s3_bucket_id}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "app_policy_attach" {
  role       = module.iam_assumable_role_apps.iam_role_name
  policy_arn = aws_iam_policy.app_policy.arn
}
