require "open3"

class SiteGrabber::Grabbers::CutyCapt
  include SiteGrabber::Logger
  
  DEFAULT_SERVER_OPTIONS = '"-screen 0 640x480x16"'
  DEFAULT_QUALITY = 30
  
  DEFAULT_CUTY_CAPT_FILE_NAME = 'CutyCapt'
  DEFAULT_XVFB_FILE_NAME = 'xfvb-run'
 
  attr_accessor :url, :file_path, :quality
  
  def initialize(settings) 
    @settings = settings || {}
  end
  
  def render
    execute
  rescue SystemCallError => msg
    error msg
  end
  
  def quality
    @quality || DEFAULT_QUALITY
  end
  
  protected

  def execute
    cmd = shell_command
    exit_status = nil
    debug_log { "Invoking #{cmd}" }
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      exit_status = wait_thr.value.to_i
      debug_log { "Exit status #{exit_status}" }
      stderr.lines { |l| error l } if stderr.any?    
    end
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
  
  def cuty_capt_path
    @settings[:cuty_capt_path] ||= locate_binary_file(DEFAULT_CUTY_CAPT_FILE_NAME)
    raise ArgumentError, ":cuty_capt_path setting required" unless @settings[:cuty_capt_path]
    @settings[:cuty_capt_path]
  end
  
  def xvfb_path
    @settings[:xvfb_path] ||= locate_binary_file(DEFAULT_XVFB_FILE_NAME)
    raise ArgumentError, ":xvfb_path setting required" unless @settings[:xvfb_path]
    @settings[:xvfb_path]
  end  
  
  def locate_binary_file(name)
    path = `which #{name}`.chop
    path == '' ? nil : path
  end

end