class RemoveBuildingFromPrint < ActiveRecord::Migration
  def up
    remove_column :prints, :building
  end

  def down
    add_column :prints, :building, :string
  end
end
