class AddColorToPrints < ActiveRecord::Migration
  def change
    add_column :prints, :color, :boolean
  end
end
