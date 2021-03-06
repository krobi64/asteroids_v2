class Edition < ActiveRecord::Base
  belongs_to :theme
  belongs_to :flyby
  belongs_to :orbit_diagram
  belongs_to :news_story
  belongs_to :created_by, class_name: User, primary_key: :id
  belongs_to :updated_by, class_name: User, primary_key: :id

  has_many :social_engagements

  attr_accessible :publish_date, :state, :title, :news_story, :flyby, :orbit_diagram, :theme

  before_create :initialize_shares
  before_create :set_create_user
  before_save :set_update_user

  validates :theme, presence: true, inclusion: { in: Theme.all }

  default_scope -> { order('publish_date DESC') }

  state_machine :state, initial: :draft do
    after_transition(on: :publish) do |edition, _|
      # edition.orbit_diagram.create_static_image
      edition.publish_date ||= DateTime.now
    end

    event :publish do
      transition draft: :published
    end
  end

  def initialize(*)
    super
  end

  def self.in_date_range(from, to)
    query = scoped
    query = query.where("publish_date >= '#{from.to_date}'") if from.present?
    query = query.where("publish_date <= '#{to.end_of_day.to_time}'") if to.present?
    query = query.limit(20) unless (to.present? && from.present?)
    query.all.map { |edition| edition.minimal_json }
  end

  def self.current
    where(state: 'published').limit(1).first
  end

  def self.draft
    where(state: 'draft').order('created_at DESC').limit(1).first
  end

  def self.create_draft(date, theme=Theme.classic)
    recommended_item = OrbitDiagram.most_relevant_asteroid
    edition = create(
        title: "News for #{date}",
        theme: theme
    )
    if edition.valid?
      edition.create_orbit_diagram(
          title: recommended_item.second,
          asteroid_designation: recommended_item.second
      )
      edition.create_flyby(
          title: recommended_item.second,
          content: "Relevant Date: #{recommended_item.first}, Designation: #{recommended_item.second}, Lunar Distance: #{recommended_item.last}"
      )
      edition.create_news_story(
          title: 'Create News Story',
          content: 'Enter Story Info'
      )
      edition.save!
    end

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

  def minimal_json
    {
        id: id,
        publish_date: publish_date,
        shares: total_shares.nil? ? 0 : total_shares
    }
  end

  def as_json(options_for_json={})
    {
        id: id,
        title: title,
        week_day: publish_date.presence && publish_date.strftime('%A'),
        month: publish_date.presence && publish_date.strftime('%B'),
        day: publish_date.presence && publish_date.strftime('%-d'),
        year: publish_date.presence && publish_date.strftime('%Y'),
        publish_date: publish_date,
        state: state,
        flyby: flyby,
        news_story: news_story,
        orbit_diagram: orbit_diagram,
        theme: theme,
        shares: total_shares.nil? ? 0 : total_shares
    }
  end

  private

  def set_create_user
    self.created_by = actor if actor.present?
  end

  def set_update_user
    self.updated_at = actor if actor.present?
  end
end
