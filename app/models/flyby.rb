class Flyby < ActiveRecord::Base
  belongs_to :created_by
  belongs_to :updated_by
  attr_accessible :content, :title

  validates :title, :asteroid_id, presence: true

  def as_json(options_for_json={})
    {
        title: title,
        content: content
    }
  end
end
