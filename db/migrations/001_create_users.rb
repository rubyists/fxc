Class.new Sequel::Migration do
  def up
    create_table(:users) do
      primary_key :id
      String :username, :null => false
      String :cidr, :default => "0.0.0.0/0"
      String :mailbox
      String :password
      String "vm-password"
    end unless FXC.db.tables.include? :users
  end

  def down
    remove_table(:users) if FXC.db.tables.include? :users
  end
end
