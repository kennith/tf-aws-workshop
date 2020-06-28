resource "aws_instance" "aws-linux-2" {
  ami           = var.ami_id
  instance_type = "t2.medium"

  subnet_id = aws_subnet.public.id

  tags = {
    "Name" = "Amazon Linux 2"
  }
}