resource "aws_elasticache_cluster" "cluster_redis" {
  cluster_id      = "forum-redis"
  engine          = "redis"
  engine_version  = "6.x"
  num_cache_nodes = "1"
  node_type       = "cache.t4g.micro"

  parameter_group_name = aws_elasticache_parameter_group.parameter_group_redis.name

  subnet_group_name  = aws_elasticache_subnet_group.subnet_group_elasticache.name
  security_group_ids = [aws_security_group.security_group_redis.id]
}

resource "aws_elasticache_subnet_group" "subnet_group_elasticache" {
  name = "elastichache-subnet-group"

  subnet_ids = [
    aws_subnet.subnet_private_a.id,
    aws_subnet.subnet_private_b.id,
    aws_subnet.subnet_private_c.id,
  ]
}

resource "aws_security_group" "security_group_redis" {
  name = "redis-security-group"

  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"

    cidr_blocks = [
      aws_subnet.subnet_private_a.cidr_block,
      aws_subnet.subnet_private_b.cidr_block,
      aws_subnet.subnet_private_c.cidr_block
    ]
  }
}

resource "aws_elasticache_parameter_group" "parameter_group_redis" {
  name   = "custom-redis6"
  family = "redis6.x"
}
