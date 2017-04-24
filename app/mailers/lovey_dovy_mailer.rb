class LoveyDovyMailer < ActionMailer::Base
  default from: '"LoveyDovy" <no_reply@loveydovy.com>'

  def send_signup_email(user)
    mail( :to => user.email,
          content_type: "text/html",
          body: "Dear #{user.first_name}, welcome to <a href='http://www.loveydovy.herokuapp.com/'>www.loveydovy.com</a>. To experience a great gift shopping.",
          :subject => "Welcome To LoveyDovy" )
  end
end
