r = Redis.new
Resque.redis = r
Resque.redis.namespace = "printatnd:resque"
Resque.inline = Rails.env.development?
$redis = Redis::Namespace.new("printatnd", :redis => r)

