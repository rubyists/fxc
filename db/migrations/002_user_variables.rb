Class.new Sequel::Migration do
  def up
    create_table(:user_variables) do
      primary_key :id
      String :name
      String :value
      foreign_key :user_id, :users, :null => false, :on_delete => :cascade
    end unless tables.include? :user_variables
  end

  def down
    remove_table(:user_variables) if tables.include? :user_variables #DB.tables.include? :user_variables
  end
end
