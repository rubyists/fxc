module FXC
  class RackMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      params = ::Rack::Request.new(env)
      section_dispatch(env, params)
      @app.call(env)
    end

    def section_dispatch(env, params)
      return unless section = params['section']

      path = [env['PATH_INFO'], section]

      case section
      when 'dialplan'
        dialplan(params, path)
      when 'directory'
        directory(params, path)
      when 'configuration'
        configuration(params, path)
      end

      path << params["hostname"]
      env["PATH_INFO"] = path.flatten.join('/').squeeze('/').chomp('/')
    end

    def configuration(params, path)
      path << params['key_value'] if params['key_name'] == 'name'
    end

    def dialplan(params, path)
      path << params.values_at(
        'Caller-Context',
        'Caller-Destination-Number',
        'Caller-Caller-ID-Number',
      ).compact
    end

    def directory(params, path)
      if params['purpose']
        directory_purpose(params, path)
      elsif params['action'] == 'sip_auth'
        directory_sip_auth(params, path)
      elsif params['user']
        directory_user(params, path)
      end
    end

    def directory_purpose(params, path)
      path << params['purpose'].tr('-', '_')
      path << params['sip_profile']
    end

    def directory_sip_auth(params, path)
      path << 'register'
      path << params['sip_profile']
      path << params['sip_auth_username']
    end

    def directory_user(params, path)
      if params['action'] == 'message-count'
        directory_user_message_count(params, path)
      elsif params['Event-Calling-Function']
        directory_user_event_calling_function(params, path)
      end
    end

    def directory_user_message_count(params, path)
      path << 'messages'
      path << params['user']
      path << params['key_value'] if params['tag_name'] == 'domain'
    end

    def directory_user_event_calling_function(params, path)
      case params['Event-Calling-Function']
      when /voicemail/
        directory_user_voicemail(params, path)
      when 'user_outgoing_channel'
        directory_user_outgoing_channel(params, path)
      when 'user_data_function'
        directory_user_data_function(params, path)
      end
    end

    def directory_user_voicemail(params, path)
      path << 'voicemail'
      path << params['sip_profile'] || 'default'
      path << params['user']
    end

    def directory_user_outgoing_channel(params, path)
      path << 'user_outgoing'
      path << params['user']
      path << params['domain']
    end

    def directory_user_data_function(params, path)
      path << 'user_data'
      path << params['user']
      path << params['domain']
    end
  end
end
