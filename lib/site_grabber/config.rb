class SiteGrabber::Config  
  class << self
    attr_accessor :logger, :debug, :grabber_settings, :scheduler_settings
  end
  
  @scheduler_settings = Hash.new { |k,v| k[v] = {} }
  @scheduler_settings[:class] = SiteGrabber::Schedulers::Resque  
  @scheduler_settings[:resque][:redis_prefix] = 'site_grabber'
  @scheduler_settings[:resque][:queue_name] = 'site_grabber'
  @scheduler_settings[:resque][:redis] = 'localhost:6379'
  @scheduler_settings[:callback] = Proc.new {}
  
  @grabber_settings = Hash.new { |k,v| k[v] = {} }
  @grabber_settings[:class] = SiteGrabber::Grabbers::CutyCapt
  @grabber_settings[:cuty_capt][:quality] = 30
  #  @grabber_settings[:cuty_capt][:xfvb_path] = '';
  #  @grabber_settings[:cuty_capt][:cuty_capt_path] = '';
  #  @grabber_settings[:server_options] = '';

  def self.settings_for_class(settings, class_name)
    settings_key = class_name.to_s.underscore.split('/').last.to_sym
    settings[settings_key]
  end

end