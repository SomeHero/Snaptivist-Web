class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  has_many :external_accounts, :dependent => :destroy
    # note that the user has authenticated
  # def process_authentication
  #   if (is_gifter || Parameter.is_set?(Parameter::OPEN_BETA)) && welcomed_at.nil? && !email.blank?
  #     begin
  #       TreaterMailer.send_email(:welcome_email, self)
  #     rescue => e
  #       logger.error e.message
  #       logger.error e.backtrace
  #     end
  #     self.welcomed_at = Time.now
  #     save
  #   end
  # end
  
end
