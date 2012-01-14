Class.new Sequel::Migration do
  def up
    create_table(:targets) do
      primary_key :id
      String :value, :null => false
      String :type, :default => "landline", :null => false
      Integer :priority, :default => 1, :null => false
      foreign_key :user_id, :users, :on_delete => :cascade
    end unless tables.include? :targets
  end

  def down
    remove_table(:targets) if tables.include? :targets
  end
end
