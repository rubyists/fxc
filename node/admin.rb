require 'json'

module FXC
  class Admin
    Innate.node '/admin', self
    layout(:admin){|name, wish| wish != "json" }
    provide :html, engine: :Etanni, type: 'text/html'
    provide(:json, engine: :None, type: 'application/json'){|a,o| o.map(&:values).to_json }
    helper :blue_form

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

    def context_split(name = nil)
      @contexts = FXC::Context
      @extensions = FXC::Extension
      @conditions = FXC::Condition
      @actions = FXC::Action
    end

    def extensions(context_id)
      FXC::Extension.filter(context_id: context_id.to_i)
    end

    def conditions(extension_id)
      FXC::Condition.filter(extension_id: extension_id.to_i)
    end

    def actions(condition_id)
      FXC::Action.filter(condition_id: condition_id.to_i)
    end

    def update_context
      redirect_referrer unless request.post?
      p request.params

      content = request.subset(:name, :description)

      if request[:id].empty?
        FXC::Context.create(content)
      else
        FXC::Context[request[:id].to_i].update(content)
      end

      redirect_referrer
    end

    def update_extension
      redirect_referrer unless request.post?
      p request.params

      extension = FXC::Extension[request[:id]].update(
        name: request[:name],
        description: request[:description],
        continue: (request[:continue] == 'on'),
      )

      extension.move_to(request[:position].to_i)

      redirect_referrer
    end

    def update_condition
      redirect_referrer unless request.post?
      p request.params

      condition = FXC::Condition[request[:id]]

      %w[name description matcher expression break].each do |key|
        condition.update(key.to_sym => request[key])
      end

      %w[year month mday hour minute week yday mweek wday minute\of_da].each do |key|
        value = request[key]
        if value =~ /^\d+$/
          condition.update(key.to_sym => value.to_i)
        else
          condition.update(key.to_sym => nil)
        end
      end

      condition.move_to(request[:position].to_i)

      redirect_referrer
    end

    def update_action
      redirect_referrer unless request.post?
      p request.params

      action = FXC::Action[request[:id]].update(
        name: request[:name],
        description: request[:description],
        application: request[:application],
        data: request[:data],
      )

      action.move_to(request[:position].to_i)

      redirect_referrer
    end

    def position_update
      redirect_referer unless request.post?
      p position_update: request.params

      model = {
        'conditions' => FXC::Condition,
        'contexts' => FXC::Context,
        'extensions' => FXC::Extension,
        'actions' => FXC::Action,
      }.fetch(request[:category])

      instance = model[request[:id].to_i]
      position = request[:position].to_i

      if position == 0
        instance.move_to_top
      else
        instance.move_to(position)
      end

      redirect_referrer
    end
  end
end
