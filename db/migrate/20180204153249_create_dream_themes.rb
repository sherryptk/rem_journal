class CreateDreamThemes < ActiveRecord::Migration
  def change
    create_table :dream_themes do |t|
      t.belongs_to :dream
      t.belongs_to :theme
    end
  end
end
