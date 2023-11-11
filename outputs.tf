output "ec2-public-ip" {
  value = module.terra-ec2.instance.public_ip
}