class RenameRolesMaskToRole < ActiveRecord::Migration
  def up
    rename_column :users, :roles_mask, :role
    change_column :users, :role, :string
  end

  def down
    raise IrreversibleMigration
  end
end
