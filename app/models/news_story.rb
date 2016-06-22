class NewsStory < ActiveRecord::Base
  belongs_to :source
  belongs_to :created_by
  belongs_to :updated_by
  attr_accessible :content, :story_url, :title

  validates :title, :content, presence: true

  def as_json(options_for_json={})
    {
        title: title,
        content: content
    }
  end
end
