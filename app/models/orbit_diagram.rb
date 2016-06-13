class OrbitDiagram < ActiveRecord::Base
  belongs_to :asteroid
  belongs_to :created_by
  belongs_to :updated_by
  attr_accessible :title
end
