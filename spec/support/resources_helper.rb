module ResourcesHelper
  def resource_content(name)
    dirname = File.dirname(__FILE__)
    resource_file = File.join(dirname, '..', 'resources', name)
    File.read(resource_file)
  end
end

RSpec.configure do |config|
  config.include ResourcesHelper
end
