class AddTriggerToUpdateTotalTutorTime < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      CREATE TRIGGER update_total_tutor_time_after_insert
      AFTER INSERT ON tutor_times
      FOR EACH ROW
      BEGIN
        DECLARE total_time DECIMAL(10,2);

        SELECT IFNULL(SUM(time_spent), 0.00) INTO total_time
        FROM tutor_times
        WHERE user_id = NEW.user_id;

        UPDATE users
        SET total_tutor_time = total_time
        WHERE id = NEW.user_id;
      END;
    SQL

    execute <<-SQL
      CREATE TRIGGER update_total_tutor_time_after_update
      AFTER UPDATE ON tutor_times
      FOR EACH ROW
      BEGIN
        DECLARE total_time DECIMAL(10,2);

        SELECT IFNULL(SUM(time_spent), 0.00) INTO total_time
        FROM tutor_times
        WHERE user_id = NEW.user_id;

        UPDATE users
        SET total_tutor_time = total_time
        WHERE id = NEW.user_id;
      END;
    SQL

    execute <<-SQL
      CREATE TRIGGER update_total_tutor_time_after_delete
      AFTER DELETE ON tutor_times
      FOR EACH ROW
      BEGIN
        DECLARE total_time DECIMAL(10,2);

        SELECT IFNULL(SUM(time_spent), 0.00) INTO total_time
        FROM tutor_times
        WHERE user_id = OLD.user_id;

        UPDATE users
        SET total_tutor_time = total_time
        WHERE id = OLD.user_id;
      END;
    SQL
  end

  def down
    execute "DROP TRIGGER IF EXISTS update_total_tutor_time_after_insert"
    execute "DROP TRIGGER IF EXISTS update_total_tutor_time_after_update"
    execute "DROP TRIGGER IF EXISTS update_total_tutor_time_after_delete"
  end
end
