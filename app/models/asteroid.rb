class Asteroid

  class_attribute :list, :last_read

  class << self
    def import
      unless list.present? && last_read_current?
        self.list = referenced_repo
      end
    end

    def find(designation)
      import
      list[designation]
    end

    def search(term)
      select {|a| a['designation'] =~ /#{term}/}
    end

    def all
      import unless list.present? && last_read_current?
      list.values
    end
    delegate :size, to: :all
    delegate :sample, to: :all
    delegate :[], to: :all
    delegate :index, to: :all
    delegate :select, to: :all

    private

    def last_read_current?
      last_read? && last_read > (DateTime.now - 1.day)
    end

    def referenced_repo
      loaded_repo.inject({}) do |asteroid_hash, asteroid|
        asteroid_hash[asteroid['designation']] = asteroid
        asteroid_hash
      end
    end

    def loaded_repo
      repo = JSON.load repo_file
      self.last_read = DateTime.now
      repo
    rescue StandardError => e
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace)
      list? ? list.values : raise('Asteroid List Unavailable')
    end

    def repo_file
      Rails.root.join('lib/asteroids.json')
    end

  end

  def size
    return nil unless diameter_neowise.present? || (absolute_magnitude.present? && albedo.present?)
    diameter_neowise || AsteroidMath.estimated_size(absolute_magnitude, albedo)
  end
end
