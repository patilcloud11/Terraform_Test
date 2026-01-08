resource "aws_db_instance" "Name" {
  allocated_storage = "10"
  db_name = "vishesh_db"
  identifier = "rdsdb"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  username = "admin"
  password = "awsrds123"

  vpc_security_group_ids  = []
#   db_subnet_group_name = aws_db_subnet_group.default.name
  parameter_group_name = "default.mysql8.0"

  backup_retention_period = 6
  backup_window = "00:00-01:00"

#   monitoring_interval = 60
#   monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  apply_immediately = true

  maintenance_window = "sun:00:00-sun:01:00"

  deletion_protection = true

  skip_final_snapshot = true

}


resource "aws_db_instance" "replica" {
  identifier = "replica"
  instance_class = "db.t3.micro"
  engine = "mysql"

  replicate_source_db = aws_db_instance.Name.arn
#   db_subnet_group_name = aws_db_subnet_group.rds-db_subnet_group_name
}


# resource "aws_iam_role" "rds_monitoring" {
#   name = "rds-monitoring-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "monitoring.rds.amazonaws.com"
#       }
#     }]
#   })
# }

# resource "aws_iam_policy_attachment" "rds_monitoring_attach" {
#   roles = aws_iam_role.rds_monitoring.name
# }