data "aws_ssm_parameter" "linuxAmi" {
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_key_pair" "master-key" {
  key_name   = var.pem-key
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "simple_ec2" {
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = [var.vpc_security_group_ids]
  subnet_id                   = var.public_subnet_A

  tags = {
    Name = var.instance-name
  }

  lifecycle {
      create_before_destroy = true
  }

}
