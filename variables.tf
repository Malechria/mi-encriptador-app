variable "region" {
  default = "us-east-2"
}

variable "nombres_servidores" {
  type    = list(string)
  default = ["Servidor-Ansible-1", "Servidor-Ansible-2"]
}