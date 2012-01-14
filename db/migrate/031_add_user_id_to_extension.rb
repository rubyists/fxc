Class.new Sequel::Migration do
  def up
    alter_table(:fs_extensions) do
      add_foreign_key :user_id, :users, :on_delete => :cascade
    end unless FXC.db[:fs_extensions].columns.include? :user_id

  end

  def down
    alter_table(:fs_extensions) do
      drop_column :user_id
    end if FXC.db[:fs_extensions].columns.include? :user_id
  end
end
