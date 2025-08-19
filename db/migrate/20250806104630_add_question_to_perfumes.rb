class AddQuestionToPerfumes < ActiveRecord::Migration[7.1]
  def change
    add_column :perfumes, :question, :text
  end
end
