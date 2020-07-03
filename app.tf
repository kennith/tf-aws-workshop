resource "aws_iam_role" "app_role" {
  name               = "app_role"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "attach_ssm" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "app_profile"
  role = aws_iam_role.app_role.name
}

resource "aws_instance" "web" {
  depends_on = [
    aws_iam_role.app_role
  ]

  ami           = var.ami_id
  instance_type = "t2.medium"

  vpc_security_group_ids = [
    aws_security_group.app_security_group.id
  ]

  subnet_id            = aws_subnet.public.id
  iam_instance_profile = aws_iam_instance_profile.app_profile.name
  key_name             = var.key_name

  tags = {
    "Name" = "web"
  }
}

resource "aws_instance" "app_private" {
  ami           = var.ami_id
  instance_type = "t2.medium"

  subnet_id = aws_subnet.private.id

  vpc_security_group_ids = [
    aws_security_group.app_security_group.id
  ]

  iam_instance_profile = aws_iam_instance_profile.app_profile.name
  key_name             = var.key_name

  tags = {
    "Name" = "app"
  }
}
