class AddUserToPerfumes < ActiveRecord::Migration[7.1]
  def change
    add_reference :perfumes, :user, null: true, foreign_key: true
  end
end
