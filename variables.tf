variable "ami" {
    type = string
    default = "ami-020cba7c55df1f615"
}

variable "instance_type" {
    type = string
    default = "t2.xlarge"
}

variable "key_name" {
    type = string
    default="tech365key"
}