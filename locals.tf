locals{
 bucket_name = "${var.environment}-app-uploads-asdf"
 service_account_suffix = "service-account"
 service_account_name = "${var.environment}-${local.service_account_suffix}"
 account_root_user = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"

}