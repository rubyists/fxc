require 'innate'

module FXC
  include Innate::Optioned

  options.dsl do
    o "Sequel Database URI (adapter://user:pass@host/database)", :db,
      ENV["FXC_DB"] || Pgpass.match(database: 'fxc').to_url

    o "Couch Server URI (Default: http://localhost:5984/)", :couch_uri,
      ENV["FXC_CouchURI"] || 'http://localhost:5984/fxc'

    o "Couch Database Ban (Default: fxc)", :couch_db,
      ENV["FXC_CouchDB"] || 'fxc'

    o "Log Level (DEBUG, DEVEL, INFO, NOTICE, ERROR, CRIT)", :log_level,
      ENV["FXC_LogLevel"] || "INFO"
  end
end
