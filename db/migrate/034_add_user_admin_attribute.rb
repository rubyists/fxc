Class.new Sequel::Migration do
  def up
    unless FXC.db[:users].columns.include?(:admin)
      alter_table :users do
        add_column :admin, FalseClass, default: false
      end
    end
  end

  def down
    return unless FXC.db[:users].columns.include?(:admin)

    alter_table :users do
      drop_column :admin
    end
  end
end
