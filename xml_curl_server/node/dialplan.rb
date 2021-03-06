module FXC
  class Dialplan
    Innate.node "/dialplan", self
    layout :dialplan
    helper :not_found

    def index(context = nil, number = nil, caller_id = nil, *rest)
      @context = FXC::Context.first(:name => context)
      p context: @context
      if @context
        Innate::Log.info "<<%{context}>> dialplan request: %{cid} => %{num} (%{rest})" % {
          context: context, cid: caller_id, num: number, rest: rest.join(" ")
        }
        @did = FXC::Did.first(:number.like Regexp.new(number.sub(/^1(\d{10})/,'1?\1')))
        if @did
          @user = @did.user
          name = request.params["Caller-Caller-ID-Name"] || number
          if action = @did.blocked?(number, name)
            Innate::Log.info("Blocking from #{"%s: %s" % [number, name]} to #{@did.number} with #{action}")
            begin
              render_view("blocked_#{action}")
            rescue
              render_view(:blocked_call)
            end
          else
            @targets = @did.targets
            Innate::Log.info("Routing #{@did.number} in '#{context}'. dialstring: (#{@user.dialstring})")
            # This will render the view named as the context (view/public.xhtml for public, etc)
            # or fallback to the view/did.xhtml template
            render_view(context.to_sym) rescue render_view(:did)
          end
        else
          @extensions = FXC::Extension.match(@context.id, request.params)
          p extensions: @extensions
          if @extensions.size > 0
            Innate::Log.info("Routing to #{@extensions.inspect}")
            render_view(:extension)
          else
            Innate::Log.info("No Matches!: ") # + request.inspect)
            not_found
          end
        end
      else
        Innate::Log.info("Got unhandled dialplan request: " + request.inspect)
        not_found
      end
    end

  end
end
