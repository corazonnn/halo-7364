class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.string :language
      t.string :detail
      t.string :image
      t.string :period

      t.timestamps
    end
  end
end
