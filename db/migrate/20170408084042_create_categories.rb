class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.references :city, index: true
      t.integer :sequence_id, null: false
      t.string :name, null: false
      t.string :icon, null: false
      t.text :description
      t.boolean :display_home_status, default: true
      t.string :meta_title
      t.string :meta_keyword
      t.text :meta_description
      t.boolean :active, default: true

      t.timestamps null: false
    end
    add_foreign_key :categories, :cities
  end
end
