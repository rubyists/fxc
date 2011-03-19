module FXC
  class Admin
    Innate.node '/admin', self
    layout :admin
    provide :html, engine: :Etanni, type: 'text/html'

    def index
    end

    def context(name = nil)
      if name
        context = FXC::Context.find(:name => name.downcase)
        @extensions = FXC::Extension.filter(context_id: context.id)
      else
        @extensions = FXC::Extension
      end
    end
  end
end
