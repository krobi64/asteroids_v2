class Subscription < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user

  def self.subscribed_users
    includes(:user).all.map { |subscription| subscription.user }.compact
  end
end
