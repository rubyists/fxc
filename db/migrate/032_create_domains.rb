Class.new Sequel::Migration do
  def up
    create_table(:domains) do
      primary_key :id
      String :name
      String :description
    end unless tables.include? :domains
    alter_table(:dialplan_contexts) do
      add_foreign_key :domain_id, :domains
    end
    execute "COMMENT ON TABLE domains IS 'Storage for Domains'"
  end

  def down
    remove_table(:domains) if tables.include? :domains
  end
end
