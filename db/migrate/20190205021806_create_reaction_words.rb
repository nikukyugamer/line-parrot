class CreateReactionWords < ActiveRecord::Migration[5.2]
  def change
    create_table :reaction_words do |t|
      t.string :user_message, null: false
      t.string :reply_message, null: false

      t.timestamps
    end

    add_index :reaction_words, :user_message, unique: true
  end
end
