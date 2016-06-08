class CreateFlybys < ActiveRecord::Migration
  def change
    create_table :flybys do |t|
      t.string :title
      t.text :content
      t.references :created_by
      t.references :updated_by

      t.timestamps
    end
    add_index :flybys, :created_by_id
    add_index :flybys, :updated_by_id
  end
end
