class CreatePlanets < ActiveRecord::Migration
  def change
    create_table :planets do |t|
      t.string :name
      t.integer :seed
      t.hstore :properties

      t.timestamps
    end
  end
end
