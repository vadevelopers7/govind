class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :category, index: true
      t.references :user,     index: true
      t.string :name,               null: false
      t.string :model_no
      t.decimal :price,             null: false, precision: 12, scale: 2, default: 0.00
      t.decimal :discount,                       precision: 4,  scale: 2, default: 0.00
      t.string :color
      t.boolean :display_stock_out,                                       default: true
      t.boolean :active,                                                  default: true
      t.integer :inventory,         null: false,                          default: 0
      t.text :description,                                                default: ""
      t.string :image_0
      t.string :image_1
      t.string :image_2
      t.string :meta_title
      t.string :meta_keyword
      t.text :meta_description
      t.decimal :average_rating,                 precision: 2, scale: 1,  default: 0.0
      t.integer :review_count,                                            default: 0

      t.timestamps null: false
    end
    add_foreign_key :items, :categories
    add_foreign_key :items, :users
    add_index :items, :name
  end
end
