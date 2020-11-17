class AddLanguageToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :language, :string
    add_column :users, :introduction, :string
    add_column :users, :image, :string
  end
end
