resource "aws_elasticache_cluster" "cluster_redis" {
  cluster_id      = "forum-redis"
  engine          = "redis"
  engine_version  = "6.x"
  num_cache_nodes = "1"
  node_type       = "cache.t4g.micro"

  parameter_group_name = aws_elasticache_parameter_group.parameter_group_redis.name
  security_group_ids   = [aws_security_group.security_group_redis.id]
}

resource "aws_elasticache_parameter_group" "parameter_group_redis" {
  name   = "custom-redis6"
  family = "redis6.x"
}

resource "aws_security_group" "security_group_redis" {
  name = "redis-security-group"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
