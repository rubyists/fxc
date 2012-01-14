module FXC
  class Proxy
    Innate.node "/", self
    provide :html, engine: :None
    helper :not_found

    def index(*args)
      not_found
    end
  end
end
