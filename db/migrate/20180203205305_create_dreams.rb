class CreateDreams < ActiveRecord::Migration
  def change
    create_table :dreams do |t|
      t.string :story
      t.date :date
      t.integer :user_id
    end
  end
end
