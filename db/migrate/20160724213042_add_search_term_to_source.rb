class AddSearchTermToSource < ActiveRecord::Migration
  def change
    add_column :sources, :search_term, :string
  end
end
