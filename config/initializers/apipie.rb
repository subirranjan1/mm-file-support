Apipie.configure do |config|
  config.app_name                = "FileSupportMovingstories"
  config.api_base_url            = "http://moda.movingstories.ca"
  config.doc_base_url            = "/apipie"
  config.validate = false  
  config.app_info = <<-DOC
    This app provides file support for the Moving Stories project and connectivity through the mplusmware middleware.\n
    The base URL for all API requests is "http://209.87.60.87/". At this time, all requests must use http.\n
    Authentication: Accessing data via the API requires use of an user name and password via HTTP Basic Authentication generated via
    the web front-end.\n
    The following resources are available for access, as described. Per standard RESTful practice, use the appropriate HTTP method.
  DOC

  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/*.rb"
end
