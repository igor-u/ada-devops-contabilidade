resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db-subnet-group"
  subnet_ids = [
    aws_subnet.tekuchi_public_subnet_a.id,
    aws_subnet.tekuchi_public_subnet_b.id
    ]

  tags = {
    Name = "db-subnet-group"
  }

}

resource "aws_db_instance" "tekuchi_db_instance" {
  allocated_storage    = 10
  db_name              = "tekuchidb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.m7g.large"
  username             = "admin"
  password             = "tekuchi123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible = true
  deletion_protection = false
  vpc_security_group_ids = [aws_security_group.allow_all.id]
}
