class Edition < ActiveRecord::Base
  belongs_to :theme
  belongs_to :flyby
  belongs_to :orbit_diagram
  belongs_to :news_story
  belongs_to :created_by
  belongs_to :updated_by

  has_many :social_engagements
  attr_accessible :publish_date, :state, :title, :news_story, :flyby, :orbit_diagram, :theme



  STATE = [:draft, :published].freeze

  default_scope -> { where(state: :published).order('publish_date DESC') }

  scope :current, -> { limit(1) }

  def share(social_type)
    social_engagements.first_or_create(social_type: social_type) do  |record|
      record.count = (record.count || 0) + 1
    end
    total_shares += 1
    save
  end

  def publish
    raise ArgumentError.new 'Can not publish an already published document' unless state == :draft
    update_attribute(:state, :published)
  end

end
