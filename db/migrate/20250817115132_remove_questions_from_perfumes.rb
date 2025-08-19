class RemoveQuestionsFromPerfumes < ActiveRecord::Migration[7.1]
  def change
    remove_column :perfumes, :question, :string
  end
end
