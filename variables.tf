variable "public_subnet_id" {
  type = string
  description = "Current VPC's public subnet id"
}

variable "private_subnets" {
  type = list(string)
  description = "Current VPC's private subnet cidrs"
}

variable "private_route_tables" {
  type = list(string)
  description = "List of private route table ids to update"
}

variable "prefix" {
  type = string
  description = "Project or/and environment prefix"
}

variable "on_demand" {
  type = bool
  default = false
  description = "Whether to create on-demand NAT instance instead of spot"
}

variable "vpc_id" {
  type = string
  description = "Current VPC's id"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "create_nat" {
  type = bool
  description = "Whether to create NAT instance"
}

variable "putin_khuylo" {
  type = bool
  description = "Do you agree that Putin doesn't respect Ukrainian sovereignty and territorial integrity? More info: https://en.wikipedia.org/wiki/Putin_khuylo!"
}
