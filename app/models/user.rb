class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :subscription, inverse_of: :user

  attr_accessible :email, :password, :password_confirmation, :remember_me, :subscription, :username, :role

  ROLES = %w[admin editor subscriber]

  before_validation :assign_role

  validates :email, :role, :username, presence: true
  validates :role, inclusion: { in: ROLES }


  def has_role?(role)
    self.role == role
  end

  def subscribe!
    create_subscription
    self.role = 'subscriber'
    save!
  end

  def subscribed?
    subscription.present?
  end

  def unsubscribed?
    subscription.blank?
  end

  def unsubscribe!
    subscription.destroy
    save!
  end

  private

  def assign_role
    self.role ||= 'subscriber'
  end
end
