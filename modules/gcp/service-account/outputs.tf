
output "service_account" {
  value = local.service_accounts_list[0]
}

output "service_accounts" {
  value = local.service_accounts_list
}

output "key" {
  sensitive = true
  value     = local.keys_list[0]
}

output "keys" {
  sensitive = true
  value     = local.keys_list
}

output "email" {
  value = local.emails_list[0]
}

output "emails" {
  value = zipmap(var.names, local.emails_list)
}

output "iam_email" {
  value = local.iam_emails_list[0]
}

output "iam_emails" {
  value = zipmap(var.names, local.iam_emails_list)
}
