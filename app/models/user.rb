class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_inclusion_of :role, in: ['shopper', 'retailer', 'admin']
  after_create :send_welcome_email

  def is_admin?
    self.role == "admin"
  end
  def is_shopper?
    self.role == "shopper"
  end
  def is_retailer?
    self.role == "retailer"
  end

  private
  def send_welcome_email
    mailer = LoveyDovyMailer.send_signup_email(self)
    mailer.deliver_now
  end
end
