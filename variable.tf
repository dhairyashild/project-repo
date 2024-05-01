#worker ec2 variable
variable "instance_type_worker" {
  type    = string
  default = "t2.medium"
}

#jenkins ec2 variables
variable "instance_type_jenkins" {
  type    = string
  default = "t2.small"
}

#vpc variables
variable "public_subnets" {
  type = list(string)
}

#jenkins sg variable
variable "port_worker" {
  type    = list(number)
  default = [22, 8080, 8081, 9000, 9090, ] # Example values, adjust as needed.
}

#worker-sg
variable "port_jenkins" {
  type    = list(number)
  default = [443, 8080, 22] # Example values, adjust as needed.
}
