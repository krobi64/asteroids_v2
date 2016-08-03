class OrbitDiagram < ActiveRecord::Base
  belongs_to :created_by
  belongs_to :updated_by
  has_one :edition
  attr_accessible :title, :asteroid_designation

  validates :title, presence: true
  validate :existing_asteroid, message: 'Invalid asteroid designation'

  def self.most_relevant_asteroid
    response = Net::HTTP.get URI('http://minorplanetcenter.net/next_close_approaches?asteroids=10')
    list = JSON.parse response
    list.find { |item| !published_asteroids.include?(item.second)}
  end

  def self.published_asteroids
    pluck(:asteroid_designation)
  end

  def create_static_image
    DmpUtil.generate_image(edition.orbit_diagram.asteroid_designation, edition.publish_date)
  end

  def as_json(options_for_json={})
    asteroid = Asteroid.find asteroid_designation
    {
        title: asteroid['designation'],
        asteroid_id: asteroid_designation,
        url: asteroid['url']
    }
  end

  private

  def existing_asteroid
    if Asteroid.find(asteroid_designation).blank?
      errors.add(:asteroid_designation, 'Invalid asteroid designation')
    end
  end
end
