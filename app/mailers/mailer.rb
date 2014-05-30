class Mailer < ActionMailer::Base
  default from: "admin@sfu.ca"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mailer.forgot_password.subject
  #
  def forgot_password(email, alias, new_password)
    @greeting = "Hi"
    @email = email
    @alias = alias
    @new_password = new_password
    mail to: @email, subject: "New password for Moving Stories database"
  end
end
