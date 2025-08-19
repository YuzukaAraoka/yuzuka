class AddQuestionsToPerfumes < ActiveRecord::Migration[7.1]
  def change
    add_column :perfumes, :question1, :string
    add_column :perfumes, :question2, :string
    add_column :perfumes, :question3, :string
    add_column :perfumes, :question4, :string
  end
end
