class Edition < ActiveRecord::Base
  belongs_to :theme
  belongs_to :flyby
  belongs_to :orbit_diagram
  belongs_to :news_story
  belongs_to :created_by
  belongs_to :updated_by

  has_many :social_engagements
  attr_accessible :publish_date, :state, :title, :news_story, :flyby, :orbit_diagram, :theme

  before_create :initialize_shares
  validates :theme, presence: true, inclusion: { in: Theme.all }

  default_scope -> { order('publish_date DESC') }
  scope :current, -> { where(state: 'published').limit(1) }

  state_machine :state, initial: :draft do
    after_transition(on: :publish) do |edition, _|
      edition.publish_date = DateTime.now
    end

    event :publish do
      transition draft: :published
    end
  end

  def initialize(*)
    super
  end

  def share(social_type)
    se = social_engagements.where(social_type: social_type).first
    if se.present?
      se.count +=1
    else
      social_engagements.create(social_type: social_type, count: 1)
    end
    self.total_shares += 1
    save
  end

  def initialize_shares
    self.total_shares = 0
  end

  def as_json(options_for_json={})
    {
        id: id,
        title: title,
        publish_date: publish_date,
        state: state,
        flyby: flyby,
        news_story: news_story,
        orbit_diagram: orbit_diagram,
        theme: theme,
        shares: total_shares.nil? ? 0 : total_shares
    }
  end
end
