require 'makura'

module FXC
  class Converter
    module Configuration
      module_function

      def _settings(xml, doc)
        doc[:settings] = settings = {}
        xml.xpath('settings/param').each do |param|
          settings[param[:name]] = param[:value]
        end
      end

      def _params(xml, doc)
        xml.xpath('param').each do |param|
          doc[param[:name]] = param[:value]
        end
      end

      def _modules(xml, doc)
        doc[:modules] = modules = []
        xml.xpath('modules/load').each do |load|
          modules << load[:module]
        end
      end

      class << self
        # configs with only <settings> section
        alias alsa _settings
        alias cidlookup _settings
        alias db _settings
        alias dialplan_directory _settings
        alias easyroute _settings
        alias erlang_event _settings
        alias event_multicast _settings
        alias event_socket _settings
        alias fax _settings
        alias lua _settings
        alias memcache _settings
        alias nibblebill _settings
        alias perl _settings
        alias pocketsphinx _settings
        alias portaudio _settings
        alias python _settings
        alias redis _settings
        alias sangoma_codec _settings
        alias shout _settings
        alias syslog _settings
        alias tts_commandline _settings
        alias xml_cdr _settings
        alias xml_rpc _settings
        alias zeroconf _settings

        # configs with only <modules> section
        alias modules _modules
        alias post_load_modules _modules
        alias spidermonkey _modules
      end

      def acl(xml, doc)
        doc['network-lists'] = lists = {}
        xml.xpath('network-lists/list').each do |list|
          nodes = []
          lists[list[:name]] = lh = {default: list[:default], nodes: nodes}
          list.xpath('node').each do |node|
            nodes << h = {}
            node.attributes.each do |key, attribute|
              h[key] = attribute.value
            end
          end
        end
      end

      def callcenter(xml, doc)
        _settings(xml, doc)

        doc[:queues] = queues = {}
        xml.xpath('queues/queue').each do |queue|
          queues[queue[:name]] = qh = {}
          _params(queue, qh)
        end

        doc[:agents] = agents = {}
        xml.xpath('agents/agent').each do |agent|
          agents[agent[:name]] = ah = {}
          agent.attributes.each do |key, attribute|
            ah[key] = attribute.value
          end
        end

        doc[:tiers] = tiers = []
        xml.xpath('tiers/tier').each do |tier|
          tiers << th = {}
          tier.attributes.each do |key, attribute|
            th[key] = attribute.value
          end
        end
      end

      def cdr_csv(xml, doc)
        _settings(xml, doc)
        doc[:templates] = templates = {}
        xml.xpath('templates/template').each do |template|
          templates[template[:name]] = template.inner_text
        end
      end

      def cdr_pg_csv(xml, doc)
        _settings(xml, doc)
        doc[:schema] = schema = {}

        xml.xpath('schema/field').each do |field|
          schema[field[:var]] = fh = {}
          field.attributes.each do |key, attribute|
            fh[key] = attribute.value unless key == 'var'
          end
        end
      end

      def cdr_sqlite(xml, doc)
        _settings(xml, doc)
        doc[:templates] = templates = {}
        xml.xpath('templates/template').each do |template|
          templates[template[:name]] = template.text
        end
      end

      def conference(xml, doc)
        doc[:advertise] = advertise = {}
        xml.xpath('advertise/room').each do |room|
          advertise[room[:name]] = room[:status]
        end

        doc['caller-controls'] = caller_controls = {}
        xml.xpath('caller-controls/group').each do |group|
          caller_controls[group[:name]] = gh = {}
          group.xpath('control').each do |control|
            gh[control[:action]] = control[:digits]
          end
        end

        doc['profiles'] = profiles = {}
        xml.xpath('profiles/profile').each do |profile|
          profiles[profile[:name]] = ph = {}
          _params(profile, ph)
        end
      end

      def console(xml, doc)
        doc[:mappings] = mappings = {}
        xml.xpath('mappings/map').each do |map|
          mappings[map[:name]] = map[:value].scan(/[^,\s]+/)
        end

        _settings(xml, doc)
      end

      def dingaling(xml, doc)
        _settings(xml, doc)

        doc[:profiles] = profiles = []
        xml.xpath('profile').each do |profile|
          params = {}
          profiles << ph = {type: profile[:type], params: params}
          _params(profile, ph)
        end
      end

      def directory(xml, doc)
        _settings(xml, doc)

        doc[:profiles] = profiles = {}
        xml.xpath('profiles/profile').each do |profile|
          profiles[profile[:name]] = ph = {}
          _params(profile, ph)
        end
      end

      def distributor(xml, doc)
        doc[:lists] = lists = {}
        xml.xpath('lists/list').each do |list|
          nodes = []
          lists[list[:name]] = {
            'total-weight' => list['total-weight'].to_i,
            'nodes' => nodes,
          }
          list.xpath('node').each do |node|
            nodes << {name: node[:name], weight: node[:weight].to_i}
          end
        end
      end

      def enum(xml, doc)
        _settings(xml, doc)
        doc[:routes] = routes = []
        xml.xpath('routes/route').each do |route|
          routes << route.attributes
        end
      end

      def fifo(xml, doc)
        _settings(xml, doc)

        doc['fifos'] = fifos = {}
        xml.xpath('fifos/fifo').each do |fifo|
          fifos[fifo[:name]] = fh = {}
          fifo.attributes.each do |key, attribute|
            fh[key] = attribute.value unless key == "name"
          end

          fh[:members] = members = {}
          fifo.xpath('member').each do |member|
            members[member.text] = mh = {}
            member.attributes.each do |key, attribute|
              mh[key] = attribute.value
            end
          end
        end
      end

      def hash(xml, doc)
        doc[:remotes] = remotes = {}
        xml.xpath('remotes/remote').each do |remote|
          remotes[remote[:name]] = rh = {}
          remote.attributes.each do |key, attribute|
            rh[key] = attribute.value unless key == 'name'
          end
        end
      end

      def ivr(xml, doc)
        doc[:menus] = menus = {}
        xml.xpath('menus/menu').each do |menu|
          entries = []
          attributes = {}
          menus[menu[:name]] = mh = {attributes: attributes, entries: entries}

          menu.attributes.each{|key, attribute| attributes[key] = attribute.value }

          menu.xpath('entry').each do |entry|
            entries << h = {}
            entry.attributes.each{|key, attribute| h[key] = attribute.value }
          end
        end
      end

      def java(xml, doc)
        doc[:javavm] = xml.at('javavm')[:path]
        doc[:options] = options = []
        xml.xpath('options/option').each do |option|
          options << option[:value]
        end

        doc[:startup] = startup = {}
        xml.at('startup').attributes.each do |key, attribute|
          startup[key] = attribute.value
        end

        doc[:shutdown] = shutdown = {}
        xml.at('shutdown').attributes.each do |key, attribute|
          shutdown[key] = attribute.value
        end
      end

      def lcr(xml, doc)
        _settings(xml, doc)

        doc[:profiles] = profiles = {}
        xml.xpath('profiles/profile').each do |profile|
          profiles[profile[:name]] = ph = {}
          _params(profile, ph)
        end
      end

      def local_stream(xml, doc)
        doc[:directories] = directories = {}
        xml.xpath('directory').each do |directory|
          directories[directory[:name]] = dh = {}
          dh[:path] = directory[:path]
          _params(directory, dh)
        end
      end

      def logfile(xml, doc)
        doc[:profiles] = profiles = {}
        xml.xpath('profiles/profile').each do |profile|
          profiles[profile[:name]] = ph = {}
          _settings(profile, ph)
          ph[:mappings] = pm = {}
          profile.xpath('mappings/map').each do |map|
            pm[map[:name]] = map[:value].scan(/[^\s,]+/)
          end
        end

        _settings(xml, doc)
      end

      def opal(xml, doc)
        _settings(xml, doc)

        doc[:listeners] = listeners = {}
        xml.xpath('listeners/listener').each do |listener|
          listeners[listener[:name]] = lh = {}
          _params(listener, lh)
        end
      end

      def osp(xml, doc)
        _settings(xml, doc)
        doc[:profiles] = profiles = {}
        xml.xpath('profiles/profile').each do |profile|
          profiles[profile[:name]] = ph = {}
          _params(profile, ph)
        end
      end

      def rss(xml, doc)
        doc[:feeds] = feeds = {}
        xml.xpath('feeds/feed').each do |feed|
          feeds[feed[:name]] = feed.text
        end
      end

      def skinny(xml, doc)
        doc[:profiles] = profiles = {}

        xml.xpath('profiles/profile').each do |profile|
          settings = {}
          soft_key_set_sets = {}
          device_types = {}
          profiles[profile[:name]] = ph = {
            'soft-key-set-sets' => soft_key_set_sets,
            'device-types' => device_types,
          }

          _settings(profile, ph)

          profile.xpath('soft-key-set-sets/soft-key-set-set').each do |skss|
            soft_key_set_sets[skss[:name]] = sh = {}
            skss.xpath('soft-key-set').each do |sks|
              sh[sks[:name]] = sks[:value]
            end
          end

          profile.xpath('device-types/device-type').each do |device_type|
            device_types[device_type[:id]] = dh = {}
            _params(device_type, dh)
          end
        end
      end

      def sofia(xml, doc)
        doc[:global_settings] = global_settings = {}
        xml.xpath('global_settings/param').each do |param|
          global_settings[param[:name]] = param[:value]
        end

        doc[:profiles] = profiles = {}
        xml.xpath('profiles/profile').each do |profile|
          profiles[profile[:name]] = ph = {}
          _settings(profile, ph)

          ph[:aliases] = profile.xpath('aliases/alias').map{|a| a[:name] }
          ph[:domains] = domains = {}
          profile.xpath('domains/domain').each do |domain|
            domains[domain[:name]] = {
              alias: domain[:alias] == 'true',
              parse: domain[:parse] == 'true',
            }
          end

          ph[:gateways] = gateways = {}

          xml.xpath('gateways/gateway').each do |gateway|
            gateways[gateway[:name]] = gh = {}
            _params(gateway, gh)
          end
        end
      end

      def spandsp(xml, doc)
        doc[:descriptors] = descriptors = {}
        xml.xpath('descriptors/descriptor').each do |descriptor|
          descriptors[descriptor[:name]] = dh = {}
          descriptor.xpath('tone').each do |tone|
            dh[tone[:name]] = ta = []
            tone.xpath('element').each do |element|
              ta << tah = {}
              element.attributes.each do |key, attribute|
                tah[key] = attribute.value.to_i
              end
            end
          end
        end
      end

      def switch(xml, doc)
        doc['cli-keybindings'] = keys = {}
        xml.xpath('cli-keybindings/key').each do |key|
          keys[key[:name]] = key[:value]
        end

        doc['default-ptimes'] = ptimes = {}
        xml.xpath('default-ptimes/codec').each do |codec|
          ptimes[codec[:name]] = codec[:ptime].to_i
        end

        _settings(xml, doc)
      end

      def timezones(xml, doc)
        doc[:timezones] = timezones = {}
        xml.xpath('timezones/zone').each do |zone|
          timezones[zone[:name]] = zone[:value]
        end
      end

      def unicall(xml, doc)
        _settings(xml, doc)

        doc[:spans] = spans = {}
        xml.xpath('spans/span').each do |span|
          spans[span[:id]] = sh = {}
          _params(span, sh)
        end
      end

      def unimrcp(xml, doc)
        _settings(xml, doc)

        doc[:profiles] = profiles = {}
        xml.xpath('profiles/profile').each do |profile|
          params = {}
          synthparams = {}
          recogparams = {}
          profiles[profile[:name]] = ph = {
            version: profile[:version],
            params: params, synthparams: synthparams, recogparams: recogparams,
          }

          _params(profile, params)

          profile.xpath('synthparams/param').each do |param|
            synthparams[param[:name]] = param[:value]
          end

          profile.xpath('recogparams/param').each do |param|
            recogparams[param[:name]] = param[:value]
          end
        end
      end

      def voicemail(xml, doc)
        _settings(xml, doc)

        doc[:profiles] = profiles = {}
        xml.xpath('profiles/profile').each do |profile|
          profiles[profile[:name]] = ph = {}

          _params(profile, ph)

          ph[:email] = email = {}
          profile.xpath('email/param').each do |param|
            email[param[:name]] = param[:value]
          end
        end
      end

      def xml_curl(xml, doc)
        doc[:bindings] = bindings = {}

        xml.xpath('bindings/binding').each do |binding|
          bindings[binding[:name]] = params = {}

          binding.xpath('param').each do |param|
            if param[:name] == 'gateway-url'
              params[:config] = {
                'gateway-url' => param[:value],
                'bindings' => param[:bindings],
              }
            else
              params[param[:name]] = param[:value]
            end
          end
        end
      end
    end
  end
end
