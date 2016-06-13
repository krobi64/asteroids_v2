class Edition < ActiveRecord::Base
  belongs_to :theme
  belongs_to :flyby
  belongs_to :orbit_diagram
  belongs_to :news_story
  belongs_to :created_by
  belongs_to :updated_by
  attr_accessible :publish_date, :state, :title, :total_shares

  STATE = [:draft, :published].freeze

end
