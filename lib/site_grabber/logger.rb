module SiteGrabber::Logger
  def log(severity, message)
    log_message = "[SiteGrabber:#{severity}] #{message}"
    puts log_message if debug
    logger.send(severity, log_message) if logger
  end

  def debug_log(&block)
    return unless debug?
    log_message = "[IloopReporting:DEBUG] #{block.call}"
    logger.info(log_message) if logger
  end
  
  def error(message)
    log(:error, message)
  end
  
  def info(message)
    log(:info, message)
  end
  
  def logger
    SiteGrabber.config.logger
  end

  def debug?
    SiteGrabber.config.debug
  end
end