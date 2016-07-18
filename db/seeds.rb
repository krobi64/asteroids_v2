# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
include LoremIpsum::Base

Theme.create name: 'classic'
Theme.create name: 'modern'
Source.create name: 'JPL Asteroid Watch', url: 'http://www.jpl.nasa.gov/asteroidwatch/'

@first_day = Date.today - 25.days

  def create_data
    (25.downto 1).each do |n|
      e = Edition.create! sample_edition(n), without_protection: true
      e.create_flyby sample_flyby(n)
      e.create_news_story sample_news(n)
      e.create_orbit_diagram sample_orbit
      e.save!
      unless n == 25
        e.publish!
        e.publish_date = @first_day + n.days
        e.save!
      end
    end
  end

  def sample_edition(n=1)
    {
        title: "News Title for #{n}",
        theme: Theme.all.sample,
        total_shares: 0
    }
  end

  def sample_news(n=1)
    {
        title: "News of #{@first_day + n.days}",
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
create_data

