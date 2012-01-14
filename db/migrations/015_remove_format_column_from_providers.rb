Class.new Sequel::Migration do
  def up
    alter_table(:providers) do
      drop_column :format
    end
  end

  def down
    alter_table(:targets) do
      add_column :format, String, :null => false
    end
  end
end
