class AddCommentsCountToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :comments_count, :integer, default: 0
  end
end
