Apipie.configure do |config|
  config.app_name                = "FileSupportMovingstories"
  config.api_base_url            = ""
  config.doc_base_url            = "/apipie"
  config.validate = false  
  config.app_info                = "This app provides file support for the Moving Stories/mplusmm middleware database. All calls are validated using HTTP Basic Authentication with user name and password the same as a front-end login."
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/*.rb"
end
