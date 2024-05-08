module "vpc" {
    source = "git@github.com:bhargavimandala/terraform-aws-vpc-module.git?ref=v1.8"
    cidr_block = "10.0.0.0/21"
    product = "clientelety"
    environment = "dev"
    terraform_repo = "https://github.com/bhargavimandala/terraform-aws-vpc-module.git"
    costcode = 111
    publicsubnet_cidr = "10.0.0.0/23,10.0.2.0/23"
    public_az = "eu-west-2a,eu-west-2b"
    privatesubnet_cidr = "10.0.4.0/23,10.0.6.0/23"
    private_az= "eu-west-2a,eu-west-2b"
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = module.vpc.vpc_id
  cidr_block = "100.0.0.0/16"
  depends_on = [ module.vpc ]
}

# create public subnet

resource "aws_subnet" "public_subnets_secondary" {
  count = length(split(",",var.public_secondary_cidr))  
  vpc_id     = module.vpc.vpc_id
  cidr_block = element(split(",",var.public_secondary_cidr), count.index)
  availability_zone = element(split(",",var.public_secondary_az), count.index)

  tags = {
            Name = "${var.global_product}.${var.global_environment}-public_subnets.${count.index  + 1}" 
  }
}

#craeting private subnet

### private subnets ####
resource "aws_subnet" "private_subnets_secondary" {
  count = length(split(",",var.private_subnet_secondary))
  vpc_id     = module.vpc.vpc_id
  cidr_block = element(split(",",var.private_subnet_secondary), count.index)
  availability_zone = element(split(",",var.private_secondary_az), count.index)

  tags = {
    Name = "${var.global_product}.${var.global_environment}-private _subnets.${count.index  + 1}" 
  }
}


######### private routetable #########
resource "aws_route_table" "private_routetable_secondary" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${var.global_product}.${var.global_environment}-private_routetable"
  }
}

###### associate public subnets to the public routetable ##########
resource "aws_route_table_association" "public_routetable_assoc_secondary" {
  count          =          length(split(",",var.public_secondary_cidr))  
  subnet_id      =          element(aws_subnet.public_subnets_secondary.*.id, count.index)
  route_table_id =          module.vpc.default_route_table
}

###### associate private subnets to the private routetable ##########sss
resource "aws_route_table_association" "private_routetable_assoc_secondary" {
  count          =          length(split(",",var.private_subnet_secondary))  
  subnet_id      =          element(aws_subnet.private_subnets_secondary.*.id, count.index)
  route_table_id =          element(aws_route_table.private_routetable_secondary.*.id, count.index)
}