resource "aws_iam_role" "ec2_ecr_role" {
  name = "ec2-ecr-access-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy_attachment" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_ecr_profile" {
  name = "ec2-ecr-access-profile"
  role = aws_iam_role.ec2_ecr_role.name
}

resource "aws_instance" "main" {
  ami                  = var.ami
  instance_type        = var.instance_type
  subnet_id            = var.public_subnet
  security_groups      = [var.security_group_id]
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_ecr_profile.name
  tags                 = var.tags

  user_data = <<-EOF
              #!/bin/bash
              # Update and upgrade the instance
              apt update && apt upgrade -y
              
              # Disable swap (required for k3s)
              swapoff -a
              sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

              # Obtain the public IP and AWS account ID from metadata
              TOKEN=$(curl -s --max-time 10 --retry 5 --retry-delay 0 --retry-max-time 40 -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
              PUBLIC_IP=$(curl -s --max-time 10 --retry 5 --retry-delay 0 --retry-max-time 40 -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)
              ACCOUNT_ID=$(curl -s --max-time 10 --retry 5 --retry-delay 0 --retry-max-time 40 -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .accountId)
              REGION=$(curl -s --max-time 10 --retry 5 --retry-delay 0 --retry-max-time 40 -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)

              # Install k3s
              curl -sfL https://get.k3s.io | sh -

              # Install jq and AWS CLI
              apt-get install -y jq unzip
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install

              # Retrieve ECR authentication token
              ECR_TOKEN=$(aws ecr get-login-password --region $REGION)

              # Create Docker registry secret in Kubernetes
              kubectl delete secret ecr-registry || true
              kubectl create secret docker-registry ecr-registry \
                --docker-server=https://$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com \
                --docker-username=AWS \
                --docker-password=$ECR_TOKEN

              echo "tls-san:" > /etc/rancher/k3s/config.yaml
              echo "  - $PUBLIC_IP" >> /etc/rancher/k3s/config.yaml
              systemctl restart k3s
              EOF
}


output "instance_ids" {
  value = aws_instance.main.id
}

output "instance_public_ips" {
  value = aws_instance.main.public_ip
}
