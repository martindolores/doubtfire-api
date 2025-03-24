class CreateTutorTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :tutor_times do |t|
      t.references :user, null: false, foreign_key: true  # Links to users table
      t.references :task, null: false, foreign_key: true  # Links to tasks table
      t.integer :time_spent, null: false, default: 0       # Time spent in minutes
      t.timestamps
    end
  end
end
