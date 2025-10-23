resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"

  client_id_list  = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  tags = {
    Name        = "GitHubActionsOIDC"
    Environment = var.environment
  }
}

resource "aws_iam_role" "github_oidc_role" {
  name               = "${var.environment}GitHubOidcRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"

        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = [
              "sts.amazonaws.com"
            ]
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:YoniKap/*"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_oidc_ecr_policy" {
  name        = "${var.environment}GitHubOidcEcrPolicy"
  description = "Policy to allow GitHub Actions to push to ECR"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:DescribeRepositories",
          "ecr:CreateRepository"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_oidc_ecr_attachment" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = aws_iam_policy.github_oidc_ecr_policy.arn
}
