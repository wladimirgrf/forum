resource "aws_elasticache_cluster" "cluster_redis" {
  cluster_id      = "forum-redis"
  engine          = "redis"
  engine_version  = "6.x"
  num_cache_nodes = "1"
  node_type       = "cache.t4g.micro"

  parameter_group_name = aws_elasticache_parameter_group.parameter_group_redis.name
}

resource "aws_elasticache_parameter_group" "parameter_group_redis" {
  name   = "custom-redis6"
  family = "redis6.x"
}
