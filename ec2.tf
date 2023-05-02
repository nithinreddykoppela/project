data "template_file" "webserverinit" {
  template = file("${path.module}/user_data.sh")
  vars = {
    efs_dns_name = aws_efs_file_system.demo_efs.dns_name
    region = var.AWS_REGION
  }
}

data "template_cloudinit_config" "webserverinit" {
  gzip = false
  base64_encode = false 

  part {
    content_type = "text/x-shellscript"
    content = data.template_file.webserverinit.rendered
  }
}

resource "aws_instance" "webserver" {
  count                  = 2
  ami                    = var.SERVER_AMI
  instance_type          = var.SERVER_PROFILE
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = module.vpc.public_subnets[count.index]
  key_name               = aws_key_pair.generated_key.key_name
  # user_data              = data.template_cloudinit_config.webserverinit.rendered
  user_data              = data.template_cloudinit_config.webserverinit.rendered

  tags = {
    Name = "web-server-${count.index + 1}-${var.ENVIRONMENT}"
  }
}


resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "ec2-efs-access-key"
  public_key = tls_private_key.key.public_key_openssh
}


resource "null_resource" "configure_nfs" {
  count = 2
  depends_on = [aws_efs_mount_target.demo_efs_mount_target, aws_lb.demo_elb]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = tls_private_key.key.private_key_pem
    host     = aws_instance.webserver[count.index].public_ip
  }
  provisioner "remote-exec" {
    inline = [
        "sudo apt update -y",
        "sudo apt install -y nginx",
        "sudo git clone https://github.com/cloudacademy/static-website-example",
        "sudo cd static-website-example",
        "sudo mv * /var/www/html/",
        "sudo systemctl start nginx",
        "sudo systemctl enable nginx",
        "sudo apt -y install nfs-client nfs-common cifs-utils",
        "sudo mkdir -p /efs",
        # "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.demo_efs.id}.efs.${var.AWS_REGION}.amazonaws.com: /efs",
        # "sudo echo ${aws_efs_file_system.demo_efs.id}.efs.${var.AWS_REGION}.amazonaws.com:/ /efs nfs defaults,_netdev 0 0 >> /etc/fstab"
    ]
  }
}

# fs-02e0f49660d4a9141.efs.ap-south-1.amazonaws.com
# fs-02e0f49660d4a9141.efs.ap-south-1.amazonaws.com

# fs-02e0f49660d4a9141.efs.ap-south-1.amazonaws.com
# sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.demo_efs.id}.efs.${var.REGION}.amazonaws.com.cn:/

# sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-02e0f49660d4a9141.efs.ap-south-1.amazonaws.com:/ efs