output "bastion_public_ip" {
  description = "Adresse IP publique du bastion"
  value       = aws_instance.bastion.public_ip
}

output "bastion_ssh_command" {
  description = "Commande SSH pour se connecter au bastion"
  value       = "ssh -i ~/.ssh/aws-ec2.pub ubuntu@${aws_instance.bastion.public_ip}"
}

output "api_server_public_ip" {
  description = "Adresse IP publique du serveur API"
  value       = aws_instance.api_server.public_ip
}