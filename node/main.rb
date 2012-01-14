module FXC
  class Controller < Ramaze::Controller
    layout :main
    engine :Etanni
  end

  class Main < Controller
    map '/'

    def index
    end
  end
end
