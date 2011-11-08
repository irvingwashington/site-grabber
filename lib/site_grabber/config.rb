class SiteGrabber::Config
  class << self
    attr_accessor :logger, :debug
  end

  def self.adapter_settings(adapter_name)
    @adapter_settings ||= {}
    @adapter_settings[adapter_name] ||= {}
  end
end