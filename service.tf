resource "aws_vpc" "myVPC" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "mySub" {
  vpc_id                  = aws_vpc.myVPC.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myVPC.id

}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.mySub.id
  route_table_id = aws_route_table.rt.id

}

resource "aws_security_group" "sg" {
  name   = "sg"
  vpc_id = aws_vpc.myVPC.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Traffic to internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["103.189.135.190/32"]
  }


}

resource "aws_instance" "myInstance" {
  ami                    = "ami-0b6d9d3d33ba97d99"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.mySub.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data_base64       = filebase64("userdata.sh")



}

//remote backend
resource "aws_s3_bucket" "myBucket" {
  bucket = "gitactions-demo-15"
  region = "us-east-1"

}