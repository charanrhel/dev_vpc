resource "aws_security_group" "apache_sg" {
  name        = "apache_sg"
  description = "Access for the application"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description     = "SSH for Admins"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    /* cidr_blocks = ["0.0.0.0/0"] */
  }

  ingress {
    description = "End User access for applcation"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "apache_sg"
  }
}

resource "aws_instance" "apache" {
 // vpc_id                      = aws_vpc.dev_vpc.id
  subnet_id                   = "${aws_subnet.dev_private[0].id}"
  ami                         = "ami-0a606d8395a538502"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.apache_sg.id]
  user_data                   = "${file("apache.sh")}"
  key_name                    = aws_key_pair.dev_newkey.id
  
  depends_on = [
    aws_security_group.bastion_sg
  ]

  tags = {
    Name = "Apache"
  }
}