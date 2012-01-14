Class.new Sequel::Migration do
  def up
    create_table(:voicemail_msgs) do
      Integer :created_epoch
      Integer :read_epoch
      String :username
      String :domain
      String :uuid
      String :cid_name
      String :cid_number
      String :in_folder
      String :file_path
      Integer :message_len
      String :flags
      String :read_flags

    end unless FXC.db.tables.include? :voicemail_msgs
  end

  def down
    remove_table(:voicemail_msgs) if FXC.db.tables.include? :voicemail_msgs
  end
end
