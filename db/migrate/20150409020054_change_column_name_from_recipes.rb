class ChangeColumnNameFromRecipes < ActiveRecord::Migration
  def change
    remove_column :recipes, :isntructions
    add_column    :recipes, :instructions, :text
  end
end
