class AddOptionToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :option, :string
  end
end
