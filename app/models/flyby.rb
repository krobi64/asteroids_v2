class Flyby < ActiveRecord::Base
  belongs_to :created_by, class_name: User, primary_key: :id
  belongs_to :updated_by, class_name: User, primary_key: :id

  has_one :edition

  attr_accessor :actor

  attr_accessible :content, :title

  before_create :set_create_user
  before_save :set_update_user

  validates :title, presence: true

  def as_json(options_for_json={})
    {
        title: title,
        content: content
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
