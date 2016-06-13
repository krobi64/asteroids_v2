class Flyby < ActiveRecord::Base
  belongs_to :created_by
  belongs_to :updated_by
  attr_accessible :content, :title
end
