class CreateTweets < ActiveRecord::Migration[7.1]
  def change
    create_table :tweets do |t|
      t.string :title
      t.string :information
      t.string :image
      t.string :comment

      t.timestamps
    end
  end
end
