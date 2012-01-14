Class.new Sequel::Migration do
  def up
    alter_table(:fs_conditions) do
      add_column :year, String
      add_column :yday, String
      add_column :mon, String
      add_column :mday, String
      add_column :week, String
      add_column :mweek, String
      add_column :wday, String
      add_column :hour, String
      add_column :minute, String
      add_column :minute_of_day, String
    end

  end

  def down
    alter_table(:fs_conditions) do
      drop_column :year
      drop_column :yday
      drop_column :mon
      drop_column :mday
      drop_column :week
      drop_column :mweek
      drop_column :wday
      drop_column :hour
      drop_column :minute
      drop_column :minute_of_day
    end
  end
end
