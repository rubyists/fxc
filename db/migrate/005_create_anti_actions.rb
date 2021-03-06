Class.new Sequel::Migration do
  def up
    create_table(:fs_anti_actions) do
      primary_key :id
      String :name
      String :description
      String :application
      String :data
      Integer :position, :null => false
      foreign_key :condition_id, :fs_conditions, :on_update => :cascade, :on_delete => :cascade
    end unless FXC.db.tables.include? :fs_anti_actions
    execute "COMMENT ON TABLE fs_anti_actions IS 'Storage for Dialplan actions'"
    execute "COMMENT ON COLUMN fs_anti_actions.name IS 'The name of this action'"
    execute "COMMENT ON COLUMN fs_anti_actions.description IS 'Description of this action'"
    execute "COMMENT ON COLUMN fs_anti_actions.application IS 'Which application to run'"
    execute "COMMENT ON COLUMN fs_anti_actions.data IS 'The arguments to send to the application'"
    execute "COMMENT ON COLUMN fs_anti_actions.position IS 'The order to perform actions in'"
    execute "COMMENT ON COLUMN fs_anti_actions.condition_id IS 'The associated condition record'"
  end

  def down
    drop_table(:fs_anti_actions) if FXC.db.tables.include? :fs_anti_actions
  end
end
