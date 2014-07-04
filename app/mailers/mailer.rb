class Mailer < ActionMailer::Base
  default from: "admin@movingstories.ca"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mailer.forgot_password.subject
  #
  def forgot_password(user, new_password)
    @email = user.email
    @alias = user.alias
    @new_password = new_password
    mail to: @email, subject: "New password for Moving Stories database"
  end
end
