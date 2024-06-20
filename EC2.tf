
# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "My VPC"
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a" # Replace with your desired availability zone
  map_public_ip_on_launch = true         # Associate a public IP address on launch

  tags = {
    Name = "My Public Subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My IGW"
  }
}

# Create a route table
resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "My Route Table"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "my_rt_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_rt.id
}

# Create a security group
resource "aws_security_group" "my_sg" {
  name        = "My Security Group"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "my_key" {
  key_name = "my_key"
  public_key = file("/home/ubuntu/Terraform/my_key.pub")
}

# Create an EC2 instance within the VPC
resource "aws_instance" "my_ec2" {
  ami                    = "ami-0149b2da6ceec4bb0" # Replace with your desired AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  associate_public_ip_address = true # Associate a public IP address
  key_name = aws_key_pair.my_key.key_name

  tags = {
    Name = "My EC2 Instance has a public IP now"
  }
}

# Output the public IP address of the EC2 instance
output "ec2_public_ip" {
  value       = aws_instance.my_ec2.public_ip
  description = "Public IP address of the EC2 instance"
}
