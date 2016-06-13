class SocialEngagement < ActiveRecord::Base
  belongs_to :edition
  attr_accessible :count, :social_type
end
