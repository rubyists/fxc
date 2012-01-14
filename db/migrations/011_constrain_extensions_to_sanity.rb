Class.new Sequel::Migration do
  def up
    alter_table :users do
      add_constraint :extension_is_digits do
        :extension.like /^[0-9]+$/
      end
      add_constraint :pin_is_digits do
        :pin.like /^([0-9]+)?$/
      end
    end
    execute("ALTER TABLE users DROP CONSTRAINT no_null_extensions")
    execute("COMMENT ON CONSTRAINT extension_is_digits ON users IS E'Extension must be all digits'")
    execute("COMMENT ON CONSTRAINT pin_is_digits ON users IS E'Pin must be all digits'")
  end

  def down
    execute "DROP CONSTRAINT extension_is_digits ON users"
    execute "DROP CONSTRAINT pin_is_digits ON users"
  end
end
