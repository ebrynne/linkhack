class AddTypeToLink < ActiveRecord::Migration
  def up
    add_column :links, :type, :text
  end
end
