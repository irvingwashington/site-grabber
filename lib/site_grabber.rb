require "site_grabber/version"

module SiteGrabber
  module Adapters
    autoload :CutyCapt, 'site_grabber/adapters/cuty_capt'
  end
  autoload :Config, 'site_grabber/config'
  autoload :Logger, 'site_grabber/logger'

  def self.config
    SiteGrabber::Config
  end

  def configure(&block)
    class_eval(&block)
  end
end
