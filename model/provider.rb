class FXC::Provider < Sequel::Model
  set_dataset FXC.db[:providers]
  def format(number)
    number.match(/^\d{10}$/) ? "sofia/external/#{format_s % number}#{port ? ":#{port}" : ""}" : number
  end

  @scaffold_human_name = 'Provider'
  @scaffold_column_types = {}

  private

  def format_s
    "%s%%s@%s" % [prefix, host]
  end
end
