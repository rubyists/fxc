module FXC
  class Admins < Controller
    map '/admin'

    def new_agent
      user = User.create(
        extension: request[:extension],
        active: true,
        password: request[:password],
        fullname: request[:name],
      )

      redirect_referrer r(:index)
    end
  end
end
