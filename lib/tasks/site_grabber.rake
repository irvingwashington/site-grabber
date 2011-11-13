require 'lib/site_grabber'

namespace :site_grabber do
  desc 'Run site grabber server'
  task :server_start do
    ENV['PIDFILE'] = './resque.pid' unless ENV.has_key?('PIDFILE')
    ENV['QUEUE'] = resque_queue_name unless ENV.has_key?('QUEUE')
    ENV['BACKGROUND'] = 'yes' unless ENV.has_key?('BACKGROUND')
    Rake::Task["resque:work"].invoke
  end
  
  desc 'Stop site grabber server'
  task :server_stop do
    
  end
  
  
  def resque_queue_name
    SiteGrabber.config.scheduler_settings[:resque][:queue_name]
  end
end