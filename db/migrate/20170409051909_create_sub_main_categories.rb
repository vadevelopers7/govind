class CreateSubMainCategories < ActiveRecord::Migration
  def change
    create_table :sub_main_categories do |t|
      t.references :main_category, index: true
      t.integer :sequence_id, null: false
      t.string :name, null: false
      t.boolean :active, default: true

      t.timestamps null: false
    end
    add_foreign_key :sub_main_categories, :main_categories
    add_index :sub_main_categories, :name
  end
end
