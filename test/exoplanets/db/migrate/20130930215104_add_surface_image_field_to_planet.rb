class AddSurfaceImageFieldToPlanet < ActiveRecord::Migration
  def change
    add_column :planets, :surface_image, :string
  end
end
