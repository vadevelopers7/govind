class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.references :state, index: true
      t.string :name, null: false
      t.string :code, null: false
      t.decimal :min_shipping_charge, precision: 12, scale: 2, default: 0.00
      t.boolean :active, default: true

      t.timestamps null: false
    end
    add_foreign_key :cities, :states
  end
end
