class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.references :subscription
      t.string :name
      t.string :value

      t.timestamps
    end
    add_index :preferences, :subscription_id
  end
end
