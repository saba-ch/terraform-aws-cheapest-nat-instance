output "eni_id" {
  description = "ID of the ENI for the NAT instance"
  value       = try(aws_network_interface.main[0].id, "")
}

output "eni_private_ip" {
  description = "Private IP of the ENI for the NAT instance"
  value = try(tolist(aws_network_interface.main[0].private_ips)[0], "")
}

output "sg_id" {
  description = "ID of the security group of the NAT instance"
  value       = try(aws_security_group.main[0].id, "")
}

output "iam_role_name" {
  description = "Name of the IAM role for the NAT instance"
  value       = try(aws_iam_role.main[0].name, "")
}