class CreateSearchInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :search_infos do |t|
      t.string :keyword
      t.text :url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
