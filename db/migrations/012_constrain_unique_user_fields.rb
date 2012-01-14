Class.new Sequel::Migration do
  def up
    alter_table :users do
      add_index :extension, :unique => true
      add_index :username, :unique => true
    end
  end

  def down
    alter_table :users do
      drop_index :extension
      drop_index :username
    end
  end
end
