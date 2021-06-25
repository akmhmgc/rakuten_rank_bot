class CreateRanks < ActiveRecord::Migration[6.0]
  def change
    create_table :ranks do |t|
      t.references :search_info, null: false, foreign_key: true
      t.integer :rank

      t.timestamps
    end
  end
end
