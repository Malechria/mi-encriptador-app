provider "aws" {
  region = var.region
}

resource "aws_security_group" "grupo_seguridad_web" {
  name        = "reglas_ansible_web"
  description = "Permitir conexiones SSH y HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}

resource "aws_instance" "mis_servidores" {
  count         = length(var.nombres_servidores)
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  
  key_name      = "NOMBRE_LLAVE_DE_TERRAFORM" 

  vpc_security_group_ids = [aws_security_group.grupo_seguridad_web.id]

  tags = {
    Name = var.nombres_servidores[count.index]
  }
}

output "ips_publicas" {
  value = aws_instance.mis_servidores[*].public_ip
}
