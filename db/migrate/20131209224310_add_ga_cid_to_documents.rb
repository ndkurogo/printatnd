class AddGaCidToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :ga_cid, :string
  end
end
