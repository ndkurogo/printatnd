class RenameUserToNetId < ActiveRecord::Migration
  def up
    rename_column :prints, :user, :netid
  end

  def down
    rename_column :prints, :netid, :user
  end
end
