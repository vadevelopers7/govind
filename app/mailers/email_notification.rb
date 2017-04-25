class EmailNotification < ApplicationMailer
  # http://guides.rubyonrails.org/action_mailer_basics.html
  def signup(user)
    mail( :to => user.email,
          content_type: "text/html",
          body: "Dear #{user.first_name}, welcome to <a href='http://www.loveydovy.herokuapp.com/'>www.loveydovy.com</a>. To experience a great gift shopping.",
          :subject => "Welcome To LoveyDovy" )
  end
end
