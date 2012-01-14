Class.new Sequel::Migration do
  def up
    create_table(:dialplan_contexts) do
      primary_key :id
      String :name, :size => 40
      String :description
    end unless tables.include? :dialplan_contexts
    execute "COMMENT ON TABLE dialplan_contexts IS 'Storage for Dialplan Contexts'"
  end

  def down
    remove_table(:dialplan_contexts) if tables.include? :dialplan_contexts
  end
end
