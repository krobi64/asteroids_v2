class CreateSocialEngagements < ActiveRecord::Migration
  def change
    create_table :social_engagements do |t|
      t.references :edition
      t.string :social_type
      t.integer :count

      t.timestamps
    end
    add_index :social_engagements, :edition_id
  end
end
