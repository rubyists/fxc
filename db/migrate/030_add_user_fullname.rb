Class.new Sequel::Migration do
  def up
    return if FXC.db[:users].columns.include?(:fullname)

    alter_table :users do
      add_column :fullname, String
    end
  end

  def down
    return unless FXC.db[:users].columns.include?(:fullname)

    alter_table :users do
      drop_column :fullname
    end
  end
end
