class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|

      t.string :name
      t.string :email
      t.float :salary
      t.string :mobile
      t.float :rating
      t.string :role
      t.integer :parent_id
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
