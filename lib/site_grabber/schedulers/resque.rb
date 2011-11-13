require 'resque'

class SiteGrabber::Schedulers::Resque

  def initialize(settings)
    Resque.redis.namespace = settings[:redis_prefix] if settings.has_key?(:redis_prefix)
    Resque.redis = settings[:redis]
  end
  
  def schedule_now(url, output_file, id)
    Resque.enqueue(SiteGrabber::Schedulers::ResqueTasks::Grab, url, output_file, id)
  end

end