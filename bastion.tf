data "external" "myipaddr" {
  program = ["bash", "-c", "curl -s 'https://ipinfo.io/json'"]
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Access for Admin users"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "SSH for Admins"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.external.myipaddr.result.ip}/32"]
    //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "bastion_sg"
  }
}

resource "aws_instance" "bastion" {
  subnet_id                   = "${aws_subnet.dev_public[1].id}"
  ami                         = "ami-0a606d8395a538502"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.dev_newkey.id 

  tags = {
    Name = "Bastion"
  }
}