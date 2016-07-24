class OrbitDiagram < ActiveRecord::Base
  belongs_to :asteroid
  belongs_to :created_by
  belongs_to :updated_by
  attr_accessible :title, :asteroid_id

  validates :title, presence: true
  validate :existing_asteroid, message: 'Invalid asteroid designation'

  def as_json(options_for_json={})
    asteroid = Asteroid[asteroid_id]
    {
        title: asteroid['designation'],
        asteroid_id: asteroid_id,
        url: asteroid['url']
    }
  end

  private

  def existing_asteroid
    unless Asteroid.find(title).present? &&
        (self.asteroid_id = Asteroid.index {|a| a['designation'] == title})
      errors.add(:title, 'Invalid asteroid designation')
    end
  end
end
