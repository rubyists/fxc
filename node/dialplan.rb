# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software
#
module FXC
  class Dialplan
    Innate.node "/dialplan", self
    layout :dialplan
    helper :not_found

    def index(context = nil, number = nil, caller_id = nil, *rest)
      @context = FXC::Context.first(:name => context)
      if @context
        Innate::Log.info("<<#{context}>> dialplan request: #{"%s => %s (%s)" % [caller_id, number, rest.join(" ")]}")
        @extensions = FXC::Extension.match(@context.id, request.params)
        if @extensions.size > 0
          Innate::Log.info("Routing to #{@extensions.inspect}")
          render_view(:extension)
        else
          Innate::Log.info("No Matches!: " + request.inspect)
          not_found
        end
      else
        Innate::Log.info("Got unhandled dialplan request: " + request.inspect)
        not_found
      end
    end
  end
end
