class LoveyDovyMailer < ActionMailer::Base
  default from: '"LoveyDovy" <no_reply@loveydovy.com>'

  def send_signup_email(user)
    mail( :to => user.email,
          :subject => "Dear #{user.first_name}, welcome to <a href='http://www.loveydovy.herokuapp.com/'>www.loveydovy.com</a>. To experience a great gift shopping." )
  end
end
