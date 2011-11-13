require "lib/site_grabber/version"
require "lib/extensions/string_extension"

module SiteGrabber
  module Grabbers
    autoload :CutyCapt, 'lib/site_grabber/grabbers/cuty_capt'
  end
  module Schedulers
    autoload :Resque, 'lib/site_grabber/schedulers/resque'
    module ResqueTasks
      autoload :Grab, 'lib/site_grabber/schedulers/resque_tasks/grab'
    end
  end
  autoload :Client, 'lib/site_grabber/client'
  autoload :Config, 'lib/site_grabber/config'
  autoload :Logger, 'lib/site_grabber/logger'

  def self.config
    SiteGrabber::Config
  end

  def configure(&block)
    class_eval(&block)
  end
end