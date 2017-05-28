class User < ActiveRecord::Base
  # Allows token auth devices to be created by calling user.create_device
  devise_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :mobile, numericality: { only_integer: true, message: "number is invalid." }, length: { is: 10, message: "number should be of 10 digits." }
  validates_inclusion_of :role, in: ['shopper', 'retailer', 'admin']
  after_create :send_registration_mail

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
  def send_registration_mail
    mailer = EmailNotification.signup(self)
    mailer.deliver_now
  end
end
