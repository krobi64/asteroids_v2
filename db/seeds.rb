# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

Theme.create name: 'classic'
Theme.create name: 'modern'
Source.create name: 'JPL Asteroid Watch', url: 'http://www.jpl.nasa.gov/asteroidwatch/'

  def create_data
    (1..25).each do |n|
      e = Edition.new sample_edition(n)
      e.create_flyby sample_flyby(n)
      e.create_news_story sample_news(n)
      e.create_orbit_diagram sample_orbit
      e.save
    end
  end

  def sample_edition(n=1)
    {
        state: 'published',
        title: "News Title for #{n}",
        theme: Theme.all.sample,
        publish_date: Date.yesterday - n.days
    }
  end

  def sample_news(n=1)
    {
        title: "News of #{Date.yesterday - n.days}",
        content: lorem_ipsum('2p').gsub(/<p>/, '').gsub(/<\/p>/, "\n").gsub(/\n\n/, "\n"),
    }
  end

  def sample_flyby(n=1)
    {
        title: "Asteroid M12#{n} is heading towarde us",
        content: "Check it out #{n} days from now"
    }
  end

  def sample_orbit
    idx = rand(Asteroid.size)
    a = Asteroid[idx]
    {
        title: a['designation'],
        asteroid_id: idx
    }
  end

# If you want to create sample data, uncomment this command:
# create_data

