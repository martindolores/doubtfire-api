class CreateTutorTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :tutor_times do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.decimal :time_spent, precision: 10, scale: 2, null: false, default: 0.0
      t.timestamps
    end
  end
end
