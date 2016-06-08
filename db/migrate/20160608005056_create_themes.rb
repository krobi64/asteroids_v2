class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name
      t.references :created_by
      t.references :updated_by

      t.timestamps
    end
    add_index :themes, :created_by_id
    add_index :themes, :updated_by_id
  end
end
