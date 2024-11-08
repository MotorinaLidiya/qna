class AddBestColumnToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :best, :boolean, null: false, default: false
    add_index :answers, :best
  end
end
