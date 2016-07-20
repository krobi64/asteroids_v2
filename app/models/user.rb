class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :subscription, inverse_of: :user

  attr_accessible :email, :password, :password_confirmation, :remember_me, :subscription, :username

  ROLES = %i[admin editor subscriber]

  def roles=(roles)
    roles = [*roles].map { |r| r.to_sym }
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def has_role?(role)
    roles.include? role
  end

  def subscribe!
    create_subscription
    self.roles = roles.push('subscriber').uniq
    save!
  end

  def unsubscribe!
    subscription.destroy
    self.roles = roles - ['subscriber']
    save!
  end
end
