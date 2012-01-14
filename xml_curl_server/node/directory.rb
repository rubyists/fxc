module FXC
  class Directory
    Innate.node "/directory", self
    layout :directory
    helper :not_found

    def index(*args)
      Innate::Log.info("Received unhandled directory request: #{request.inspect}")
      not_found
    end

    def register(profile, extension, server = nil)
      Innate::Log.debug("Received register directory request: #{request.params.inspect}")

      if user = User.from_extension(extension, server)
        Innate::Log.debug("Found user: #{user.inspect}")
        render_view(:user, :user => user)
      else
        not_found
      end
    end

    def user_data(extension, domain, server = nil)
      Innate::Log.debug("Received user_data directory request: #{request.inspect}")
      user = User.from_extension(extension, server)
      user ? render_view(:user, :user => user) : not_found
    end

    def user_outgoing(extension, domain, server = nil)
      Innate::Log.debug("Received user_outgoing directory request: #{request.inspect}")
      user = User.from_extension(extension, server)
      user ? render_view(:user, :user => user) : not_found
    end

    #TODO respond with a proper message count response (see FS wiki)
    def messages(extension, domain, server = nil)
      Innate::Log.debug("Received messages directory request: #{request.inspect}")
      user = User.from_extension(extension, server)
      user ? render_view(:user, :user => user) : not_found
    end

    def voicemail(profile, extension, server = nil)
      Innate::Log.debug("Received voicemail directory request: #{request.inspect}")
      user = User.from_extension(extension, server)
      user ? render_view(:user, :user => user) : not_found
    end

    def network_list(profile, server = nil)
      Innate::Log.debug("Received network_list directory request: #{request.inspect}")
      render_view(:users, :users => User.active_users)
    end
  end
end
