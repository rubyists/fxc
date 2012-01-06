module FXC
  class Admin
    Innate.node '/admin', self
    layout(:admin){|name, wish| wish != "json" }
    provide :html, engine: :Etanni, type: 'text/html'
    provide(:json, engine: :None, type: 'application/json'){|a,o| o.map(&:values).to_json }
    helper :blue_form

    def index
    end
  end
end
