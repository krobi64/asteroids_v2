class ChangeAsteroidIdToDesignation < ActiveRecord::Migration
  def up
    change_column :orbit_diagrams, :asteroid_id, :string
    OrbitDiagram.all.each do |od|
      designation = Asteroid[od.asteroid_id.to_i]['designation']
      od.update_attribute :asteroid_id, designation
    end
    rename_column :orbit_diagrams, :asteroid_id, :asteroid_designation
  end

  def down
    raise IrreversibleMigration
  end
end
