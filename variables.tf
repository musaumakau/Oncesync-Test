#VPC requirements
variable "custom_vpc" {
  description = "VPC for production"
  type        = string
  default     = "10.0.0.0/16"

}
#EC2 requirements
variable "instance_tenancy" {
  description = "defines tenacy of VPC"
  type        = string
  default     = "default"

}

variable "ami_id" {
  description = "ami id"
  type        = string
  default     = {
    "eu-west-1" = "ami-0a6b5206d1730bdce "
    "eu-west-1" = "ami-0a6b5206d1730bdce "
    }
}


variable "instance_type" {
  description = "instance type for the instances"
  type        = string
  default     = "t2.micro"

}

variable "ssh_private_key" {
  description = "pem file of Keypair used to login to EC2 instances"
  type        = string
  default     = "./EC2Tutorial.pem"
}

variable "repo_name" {
  type        = string
  description = "oncesync "
}

variable "repo_owner" {
  type        = string
  description = "The name of the owner of the project."
  default     = "Juan Musau"
}

variable "branch" {
  type        = string
  description = "main"
}

variable "github_token" {
  type        = string
  description = "The GitHub token associated with the AWS account."
}