class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :index
      t.string :name

      t.timestamps
    end
  end
end
