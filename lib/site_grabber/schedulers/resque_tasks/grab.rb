class SiteGrabber::Schedulers::ResqueTasks::Grab
  @queue = SiteGrabber.config.scheduler_settings[:resque][:queue_name]

  class << self
    def perform(url, output_file, id)
      grabber = grabber_instance
      grabber.url = url
      grabber.file_path = output_file
      result = grabber.render
      invoke_callback(id, result)
    end
  
    protected
    
    def invoke_callback(*args)
      callback = config.scheduler_settings[:callback]
      callback.call(*args) if callback
    end

    def grabber_instance
      grabber_class = config.grabber_settings[:class]
      grabber_settings = config.settings_for_class(config.grabber_settings, grabber_class)
      grabber_class.new(grabber_settings)
    end

    def config
      SiteGrabber.config
    end

  end  
  
end