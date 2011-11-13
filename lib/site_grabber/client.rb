class SiteGrabber::Client

  class << self  

    def schedule_grab(url, output_file, id)
      scheduler = scheduler_instance
      scheduler.schedule_now(url, output_file, id)
    end

    protected
  
    def scheduler_instance
      scheduler_class = config.scheduler_settings[:class]
      scheduler_settings = config.settings_for_class(config.scheduler_settings, scheduler_class)
      scheduler_class.new(scheduler_settings)
    end
    
    def config
      SiteGrabber.config
    end
  end
end