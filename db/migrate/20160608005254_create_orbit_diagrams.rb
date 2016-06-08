class CreateOrbitDiagrams < ActiveRecord::Migration
  def change
    create_table :orbit_diagrams do |t|
      t.string :title
      t.references :asteroid
      t.references :created_by
      t.references :updated_by

      t.timestamps
    end
    add_index :orbit_diagrams, :asteroid_id
    add_index :orbit_diagrams, :created_by_id
    add_index :orbit_diagrams, :updated_by_id
  end
end
