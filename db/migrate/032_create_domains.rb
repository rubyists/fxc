# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software
#
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
