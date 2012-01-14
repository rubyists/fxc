Class.new Sequel::Migration do
  def up
    alter_table :users do
      rename_column :extension, :old_ext
      add_column :extension, :serial, :unique => true
      drop_constraint :extension_is_digits
      drop_index :extension
    end
    execute "UPDATE users set extension = old_ext::text::integer"
    execute "SELECT setval('users_extension_seq', 3175)"
    alter_table :users do
      drop_column :old_ext
    end
  end

  def down
    alter_table :users do
      rename_column :extension, :old_ext
      add_column :extension, String, :null => false
    end
    execute "UPDATE users set extension = old_ext"
    alter_table :users do
      drop_column :old_ext
      add_index :extension, :unique => true
    end
  end
end
