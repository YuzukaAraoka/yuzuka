class CreatePerfumes < ActiveRecord::Migration[7.1]
  def change
    create_table :perfumes do |t|
      t.string :question1
      t.string :question2
      t.string :question3
      t.string :question4

      t.timestamps
    end
  end
end
