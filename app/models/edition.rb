class Edition < ActiveRecord::Base
  belongs_to :theme
  belongs_to :flyby
  belongs_to :orbit_diagram
  belongs_to :news_story
  belongs_to :created_by
  belongs_to :updated_by

  has_many :social_engagements
  attr_accessible :publish_date, :state, :title, :news_story, :flyby, :orbit_diagram, :theme

  STATE = %w[draft published].freeze
  validates :state, presence: true, inclusion: { in: STATE }
  validates :theme, presence: true, inclusion: { in: Theme.all }

  default_scope -> { order('publish_date DESC') }

  scope :draft, -> { where(state: 'draft')}
  scope :published, -> { where state: 'published' }
  scope :current, -> { published.limit(1) }

  def share(social_type)
    social_engagements.first_or_create(social_type: social_type) do  |record|
      record.count = (record.count || 0) + 1
    end
    self.total_shares = total_shares.nil? ? 1 : total_shares + 1
    save
  end

  def publish
    raise ArgumentError.new 'Can not publish an already published document' unless state == :draft
    update_attribute(:state, :published)
  end

  def as_json(options_for_json={})
    {
        title: title,
        publish_date: publish_date,
        state: state,
        flyby: flyby.to_json,
        news_story: news_story.to_json,
        orbit_diagram: orbit_diagram.to_json,
        theme: theme.to_json,
        shares: total_shares.nil? ? 0 : total_shares
    }
  end

end
