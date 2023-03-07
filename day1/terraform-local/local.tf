resource "local_file" "devops" {
	filename = "/home/ubuntu/app/day1/terraform-local/devops_automated.txt"
	content = "I want to become Engineer who knows Terraform"
	
}

resource "random_string" "rand-str" { 
length = 12
special = true
override_special = "!#$*&^%(){}[]:?;"
}

output "rand-str" {
value = random_string.rand-str[*].result
}
