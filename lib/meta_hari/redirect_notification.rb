class RedirectNotification < Exception
  attr_reader :uri
  attr_reader :iteration

  def initialize(uri, iteration)
    @uri       = uri
    @iteration = iteration
  end
end
