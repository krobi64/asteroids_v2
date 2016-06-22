class OrbitDiagram < ActiveRecord::Base
  belongs_to :asteroid
  belongs_to :created_by
  belongs_to :updated_by
  attr_accessible :title, :asteroid_id

  validates :title, :asteroid_id, presence: true

  def as_json(options_for_json={})
    asteroid = Asteroid[asteroid_id]
    {
        title: asteroid['designation'],
        asteroid_id: asteroid_id,
        url: asteroid['url']
    }
  end
end
