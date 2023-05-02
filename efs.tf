resource "aws_efs_file_system" "demo_efs" {
  creation_token = "cloud-efs-${var.ENVIRONMENT}"

  tags = {
    Name = "cloud-efs-${var.ENVIRONMENT}"
  }
}

resource "aws_efs_mount_target" "demo_efs_mount_target" {
  file_system_id = aws_efs_file_system.demo_efs.id

  subnet_id       = element(module.vpc.private_subnets, 0)
  security_groups = [aws_security_group.efs_sg.id]
}

resource "null_resource" "clean_up" {
  depends_on = [
    aws_efs_mount_target.demo_efs_mount_target
  ]  
  provisioner "local-exec" {
    command = "echo $SHELL $efs_dns_name "
  }
}