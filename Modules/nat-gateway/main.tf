# allocate elastic ip. this eip will bu used for the nat-gateway in the az1
resource "aws_eip" "eip_for_nat_gateway_az1" {
  vpc      = true
  
  tags = {
    Name = "nat gateway az1 eip"
  }
}

# allocate elastic ip. this eip will bu used for the nat-gateway in the az2
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "eip_for_nat_gateway_az2" {
  vpc      = true

  tags = {
    Name = "nat gateway az2 eip"
  }
}

# create nat gateway in public subnet az1   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = var.public_subnet_az1_id

  tags = {
    Name = "nat gateway az1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on =[var.internet_gateway] 
}

# create nat gateway in public subnet az2   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
  subnet_id     = var.public_subnet_az2_id

  tags = {
    Name = "nat gateway az2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.internet_gateway]
}

# create private root table az1 and add route through nat gateway       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "private_root_table_az1" {
  vpc_id = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az1.id
  }

  tags      = {
    Name    = "private root table az1"
  }
}

#associate private app subnet az1 with private root table         
resource "aws_route_table_association" "private_app_subnet_az1" {
  subnet_id      = var.private_app_subnet_az1_id
  route_table_id = aws_route_table.private_root_table_az1.id
}

#associate private data subnet az1 with private root table          https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "private_data_subnet_az1" {
  subnet_id      = var.private_data_subnet_az1_id
  route_table_id = aws_route_table.private_root_table_az1.id
}

# create private root table az2 and add route through nat gateway       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "private_root_table_az2" {
  vpc_id = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az2.id
  }

  tags      = {
    Name    = "private root table az2"
  }
}

#associate private app subnet az2 with private root table         
resource "aws_route_table_association" "private_app_subnet_az2" {
  subnet_id      = var.private_app_subnet_az2_id
  route_table_id = aws_route_table.private_root_table_az2.id
}

#associate private data subnet az2 with private root table          https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "private_data_subnet_az2" {
  subnet_id      = var.private_data_subnet_az2_id
  route_table_id = aws_route_table.private_root_table_az2.id
}





