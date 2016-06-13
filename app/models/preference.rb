class Preference < ActiveRecord::Base
  belongs_to :subscription
  attr_accessible :name, :value
end
