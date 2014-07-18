class AddAvatarMetaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_meta, :string
  end
end
