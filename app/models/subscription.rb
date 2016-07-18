class Subscription < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user
  validates :username, presence: true
end
