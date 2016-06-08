class AdminUser < ActiveRecord::Base
  devise :database_authenticatable,
         :confirmable, :lockable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
