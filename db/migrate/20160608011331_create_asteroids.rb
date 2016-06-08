class CreateAsteroids < ActiveRecord::Migration
  def change
    create_table :asteroids do |t|
      t.string :designation
      t.datetime :close_app_date
      t.decimal :close_app_dist
      t.float :impact_prob_float
      t.decimal :impact_prob
      t.string :taxonomy_class
      t.boolean :pha
      t.decimal :size
      t.decimal :spin_period
      t.decimal :delta_v
      t.decimal :period
      t.string :orbit_url

      t.timestamps
    end unless table_exists? :asteroids
  end
end
