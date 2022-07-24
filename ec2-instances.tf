resource "aws_iam_role" "role" {
  name = "ons-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name        = "ons-policy"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ons-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}


# Create 2 EC2 instances

resource "aws_instance" "instance" {
  count                = length(aws_subnet.public_subnet.*.id)
  ami                  = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = element(aws_subnet.public_subnet.*.id, count.index)
  security_groups      = [aws_security_group.sg.id, ]
  key_name             = "EC2Tutorial"
  iam_instance_profile = ons.aws_iam_role.iam_role.name

  tags = {
    "Name"        = "Instance-${count.index}"
    "Environment" = "Prod"
    "CreatedBy"   = "Terraform"
  }

  timeouts {
    create = "10m"
  }

}

resource "null_resource" "null" {
  count = length(aws_subnet.public_subnet.*.id)

  connection {
    type        = "ssh"
    user        = "ec2-user"
    port        = "22"
    host        = element(aws_eip.eip.*.public_ip, count.index)
    private_key = file(var.ssh_private_key)
  }

}

# Create 2 EIPS 

resource "aws_eip" "eip" {
  count            = length(aws_instance.instance.*.id)
  instance         = element(aws_instance.instance.*.id, count.index)
  public_ipv4_pool = "amazon"
  vpc              = true

  tags = {
    "Name" = "EIP-${count.index}"
  }
}

# Create EIP association with EC2 Instances

resource "aws_eip_association" "eip_association" {
  count         = length(aws_eip.eip)
  instance_id   = element(aws_instance.instance.*.id, count.index)
  allocation_id = element(aws_eip.eip.*.id, count.index)
}