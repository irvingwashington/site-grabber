require "open3"

class SiteGrabber::Adapters::CutyCapt
  include SiteGrabber::Logger
  
  DEFAULT_SERVER_OPTIONS = "-screen 0 640x480x16"
  DEFAULT_QUALITY = 30
  
  attr_accessor :url, :file_path, :quality
  
  def initialize(settings) 
    @settings = settings || {}
  end
  
  def render
    execute
  rescue SystemCallError => msg
    error msg
  end

  protected

  def execute
    cmd = shell_command
    debug { "Invoking #{cmd}" }
    stdin, stdout, stderr = Open3.popen3(cmd)
    exit_status = $?.to_i
    debug { "Exit status #{exit_status}" }
    stderr.lines { |l| error l } if stderr.any?
    exit_status.eql?(0)
  end
  
  def shell_command
    xvfb_cmd = "#{xvfb_path} -s #{server_options}"
    cc_cmd = "#{cuty_capt_path} --url=#{url} --out=#{file_path} --quality=#{quality}"
    [xvfb_cmd, cc_cmd].join(' ')
  end
  
  def server_options
    @settings[:server_options] || DEFAULT_SERVER_OPTIONS
  end
  
  def quality
    @quality || DEFAULT_QUALITY
  end
  
  def cuty_capt_path
    raise ArgumentError, "No :cuty_capt_path setting" unless @settings.has_key?(:cuty_capt_path)
    @settings[:cuty_capt_path]
  end
  
  def xvfb_path
    raise ArgumentError, "No :xvfb_path setting" unless @settings.has_key?(:xvfb_path)
    @settings[:xvfb_path]
  end  
end