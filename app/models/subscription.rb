class Subscription < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user
end
