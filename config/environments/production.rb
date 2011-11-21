Merb.logger.info("Loaded PRODUCTION Environment...")
Merb::Config.use { |c|
  c[:exception_details] = false
  c[:reload_classes] = false
  c[:log_level] = :debug
  
  c[:log_stream] = STDOUT
  c[:log_file]   = nil
  # or redirect logger using IO handle
  # c[:log_stream] = STDOUT
}

Merb::Mailer.config = {
    :host   => 'smtp.yourserver.com',
    :port   => '25',
    :user   => 'user',
    :pass   => 'pass',
    :auth   => :plain,                 # :plain, :login, :cram_md5, the default is no auth
    :domain => "localhost.localdomain" # the HELO domain provided by the client to the server
}
