class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.references :country, index: true
      t.string :name, null: false
      t.string :code, null: false

      t.timestamps null: false
    end
    add_foreign_key :states, :countries
  end
end
