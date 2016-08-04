class OrbitDiagram < ActiveRecord::Base
  belongs_to :created_by
  belongs_to :updated_by
  has_one :edition
  attr_accessible :title, :asteroid_designation

  validate :existing_asteroid, message: 'Invalid asteroid designation'

  class << self
    def most_relevant_asteroid
      response = Net::HTTP.get URI('http://minorplanetcenter.net/next_close_approaches?asteroids=10')
      list = JSON.parse response
      list.find { |item| !published_asteroids.include?(item.second)}
    end

    def published_asteroids
      pluck(:asteroid_designation)
    end

    def create_static_image(date, img_string)
      date = Time.zone.parse(date) || Time.zone.now
      file_name = "#{date.year}-#{date.month}-#{date.day}"
      file = Tempfile.new([file_name, '.png'])
      temp_file = file.path
      file.binmode
      imageBinary = Base64.strict_decode64(img_string.split(',')[1])
      file.write(imageBinary)
      file.rewind
      file.close(unlink_now: true)
      FileUtils.move(temp_file, "#{DmpUtil::FINAL_DIRECTORY_OF_IMG}/#{file_name}.png")
      # DmpUtil.generate_image(edition.orbit_diagram.asteroid_designation, edition.publish_date)
    end
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
