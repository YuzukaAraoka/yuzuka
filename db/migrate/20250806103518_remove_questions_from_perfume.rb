class RemoveQuestionsFromPerfume < ActiveRecord::Migration[7.1]
  def change
    remove_column :perfumes, :question1, :string
    remove_column :perfumes, :question2, :string
    remove_column :perfumes, :question3, :string
    remove_column :perfumes, :question4, :string
  end
end
