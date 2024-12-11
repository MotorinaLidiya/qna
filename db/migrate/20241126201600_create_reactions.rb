class CreateReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :reactions do |t|
      t.integer :value, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.belongs_to :reactionable, polymorphic: true

      t.timestamps
    end

    add_index :reactions, [:user_id, :reactionable_type, :reactionable_id], name: 'index_reactions_on_user_and_reactionable', unique: true
  end
end
