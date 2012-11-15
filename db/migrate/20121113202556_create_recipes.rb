class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :ingredient
      t.string :instruction

      t.timestamps
    end
  end
end
