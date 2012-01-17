Class.new Sequel::Migration do
  def up
    unless FXC.db[:users].columns.include?(:superman)
      alter_table :users do
        add_column :superman, FalseClass, default: false
      end
    end
    unless FXC.db[:users].columns.include?(:domain_id)
      alter_table :users do
        add_foreign_key :domain_id, :domains
      end
    end
  end

  def down
    alter_table :users do
      drop_column :superman
      drop_column :domain_id
    end
  end
end
