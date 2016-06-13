class Theme < ActiveRecord::Base
  belongs_to :created_by
  belongs_to :updated_by
  attr_accessible :name
end
