class CreateNewsStories < ActiveRecord::Migration
  def change
    create_table :news_stories do |t|
      t.string :title
      t.text :content
      t.text :story_url
      t.references :source
      t.references :created_by
      t.references :updated_by

      t.timestamps
    end
    add_index :news_stories, :source_id
    add_index :news_stories, :created_by_id
    add_index :news_stories, :updated_by_id
  end
end
