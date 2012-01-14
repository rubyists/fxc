Class.new Sequel::Migration do
  def up
    alter_table(:dialplan_contexts) do
      add_foreign_key :server_id, :servers, :on_delete => :cascade
    end unless FXC.db[:dialplan_contexts].columns.include? :server_id

  end

  def down
    alter_table(:dialplan_contexts) do
      drop_column :server_id
    end if FXC.db[:dialplan_contexts].columns.include? :server_id
  end
end
