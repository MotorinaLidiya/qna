class CreateReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :reactions do |t|
      t.integer :kind
      t.references :user, null: false, foreign_key: true
      t.belongs_to :reactionable, polymorphic: true

      t.timestamps
    end
  end
end
