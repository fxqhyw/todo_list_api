class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.boolean :done
      t.date :due_date
      t.integer :position
      t.belongs_to :project, foreign_key: true

      t.timestamps
    end
  end
end
