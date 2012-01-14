Class.new Sequel::Migration do
  def up
    alter_table(:users) do
      add_column :active, TrueClass, :default => false
    end unless FXC.db[:users].columns.include? :active
  end

  def down
    alter_table(:users) do
      drop_column :active
    end if FXC.db[:users].columns.include? :active
  end
end
