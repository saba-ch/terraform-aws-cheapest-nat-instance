# AWS Cheapest NAT Instance Module

Terraform module which creates cheapest nat instance on aws.

[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

## Usage

```hcl
module "nat_instance" {
  source = "saba-ch/cheapest-nat-instance/aws"

  public_subnet_id = module.vpc.public_subnets[0]
  private_subnets = local.private_subnets
  private_route_tables = module.vpc.private_route_table_ids
  prefix = var.prefix
  vpc_id = module.vpc.vpc_id
  create_nat = true
  putin_khuylo = true
}
```

## Create On Demand Instance

Even though this module creates highly available self healing nat instance, in production we don't want any kind of downtime. When we are using spot instances we are accepting the risk that AWS might want to reclaim the instance for any reason. To eliminate this risk we can use on demand instances instead which guarantees 99.99% SLA. 

```hcl
module "nat_instance" {
  source = "saba-ch/cheapest-nat-instance/aws"

  public_subnet_id = module.vpc.public_subnets[0]
  private_subnets = local.private_subnets
  private_route_tables = module.vpc.private_route_table_ids
  prefix = var.prefix
  vpc_id = module.vpc.vpc_id
  create_nat = true
  on_demand = true
  putin_khuylo = true
}
```

## Costs

|solution                           |network  |cost/GB|cost/hour**|cost/month**|
|-----------------------------------|---------|-------|-----------|------------|
|NAT Gateway                   |5-45 Gbps|  0.052|0.052      |37.44 without network charges |
|NAT Instance (t3a.nano)       |0-5  Gbps|0-0.09 (out)|0.0047     |3.384 without network charges |
|NAT Instance (t3a.nano) (spot)|0-5  Gbps|0-0.09 (out)|0.0017*    |1.22* without network charges|

\* variable costs.

\*\* region eu-central-1.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_eip.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_iam_instance_profile.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_launch_template.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_network_interface.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_route.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_nat"></a> [create\_nat](#input\_create\_nat) | Whether to create NAT instance | `bool` | n/a | yes |
| <a name="input_on_demand"></a> [on\_demand](#input\_on\_demand) | Whether to create on-demand NAT instance instead of spot | `bool` | `false` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Project or/and environment prefix | `string` | n/a | yes |
| <a name="input_private_route_tables"></a> [private\_route\_tables](#input\_private\_route\_tables) | List of private route table ids to update | `list(string)` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Current VPC's private subnet cidrs | `list(string)` | n/a | yes |
| <a name="input_public_subnet_id"></a> [public\_subnet\_id](#input\_public\_subnet\_id) | Current VPC's public subnet id | `string` | n/a | yes |
| <a name="input_putin_khuylo"></a> [putin\_khuylo](#input\_putin\_khuylo) | Do you agree that Putin doesn't respect Ukrainian sovereignty and territorial integrity? More info: https://en.wikipedia.org/wiki/Putin_khuylo! | `bool` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Current VPC's id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eni_id"></a> [eni\_id](#output\_eni\_id) | ID of the ENI for the NAT instance |
| <a name="output_eni_private_ip"></a> [eni\_private\_ip](#output\_eni\_private\_ip) | Private IP of the ENI for the NAT instance |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of the IAM role for the NAT instance |
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | ID of the security group of the NAT instance |
<!-- END_TF_DOCS -->


## Authors

Module is created and maintained by [Saba Tchikhinashvili](https://github.com/saba-ch)

## License

Apache 2 Licensed. See [LICENSE](https://github.com/saba-ch/cheapest-nat-instance/blob/main/LICENSE) for full details.
