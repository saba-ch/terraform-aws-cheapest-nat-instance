data "aws_region" "main" {}

locals {
  create_nat = var.create_nat && var.putin_khuylo
}

data "aws_ami" "main" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

resource "aws_autoscaling_group" "main" {
  count = local.create_nat ? 1 : 0

  name = "${var.prefix}_asg"
  vpc_zone_identifier = [var.public_subnet_id]

  mixed_instances_policy {
    instances_distribution {
      on_demand_percentage_above_base_capacity = var.on_demand ? 100 : 0
      spot_allocation_strategy = "lowest-price"
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.main[0].id
      }
      override {
        instance_type = "t3.nano"
      }
      override {
        instance_type = "t3a.nano"
      }
    }
  }

  max_size = 1
  min_size = 1
  metrics_granularity = "1Minute"
}

resource "aws_launch_template" "main" {
  name = "${var.prefix}_nat_instance_template"

  count = local.create_nat ? 1 : 0

  iam_instance_profile {
    name = aws_iam_instance_profile.main[0].name
  }

  image_id = data.aws_ami.main.id
  instance_type = "t3.nano"

  user_data = base64encode(join("\n", [
    "#cloud-config",
    yamlencode({
      write_files : [
        {
          path : "/opt/nat/runonce.sh",
          content : templatefile("${path.module}/runonce.sh", {
            region = data.aws_region.main.name
            nat_static_network_interface = aws_network_interface.main[0].id,
          }),
          permissions : "0755",
        },
      ],
      runcmd : ["/opt/nat/runonce.sh"],
    })
  ]))

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}_nat_instance_template"
    }
  )

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "${var.prefix}_nat_instance"
      }
    )
  }
}

resource "aws_route" "main" {
  count = local.create_nat ? length(var.private_route_tables) : 0

  route_table_id = var.private_route_tables[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id = aws_network_interface.main[0].id
}