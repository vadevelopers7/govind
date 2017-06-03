class CreateMainCategories < ActiveRecord::Migration
  def change
    create_table :main_categories do |t|
      t.references :city, index: true
      t.integer :sequence_id, null: false
      t.string :name, null: false
      t.string :icon, null: false
      t.boolean :active, default: true

      t.timestamps null: false
    end
    add_foreign_key :main_categories, :cities
    add_index :main_categories, :name, unique: true
  end
end
