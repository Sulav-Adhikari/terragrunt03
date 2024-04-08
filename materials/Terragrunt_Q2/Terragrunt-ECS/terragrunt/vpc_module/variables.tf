variable "vpc_subnet_module" {
  type = object({
    name               = string
    cidr_block         = string
    azs                = list(string)
    public_subnets     = list(string)
    enable_nat_gateway = bool
  })
}