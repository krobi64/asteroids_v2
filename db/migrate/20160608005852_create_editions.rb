class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.string :state
      t.string :title
      t.references :theme
      t.references :flyby
      t.references :orbit_diagram
      t.references :news_story
      t.references :created_by
      t.references :updated_by
      t.datetime :publish_date
      t.integer :total_shares

      t.timestamps
    end
    add_index :editions, :theme_id
    add_index :editions, :flyby_id
    add_index :editions, :orbit_diagram_id
    add_index :editions, :news_story_id
    add_index :editions, :created_by_id
    add_index :editions, :updated_by_id
  end
end
