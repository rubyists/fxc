Class.new Sequel::Migration do
  def up
    create_table(:voicemail_prefs) do
      String :username
      String :domain
      String :name_path
      String :greeting_path
      String :password

    end unless FXC.db.tables.include? :voicemail_prefs
  end

  def down
    remove_table(:voicemail_prefs) if FXC.db.tables.include? :voicemail_prefs
  end
end
