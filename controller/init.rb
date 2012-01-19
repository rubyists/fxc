module FXC
  class Controller < Ramaze::Controller
    layout :main
    engine :Etanni

    trait js: [
      '/js/jquery.min.js',
      '/js/modernizr.foundation.js',
      '/js/jquery.reveal.js',
      '/js/jquery.orbit-1.3.0.js',
      '/js/forms.jquery.js',
      '/js/jquery.customforms.js',
      '/js/jquery.placeholder.min.js',
      '/js/app.js',
    ]

    private

    def each_js_asset
      return to_enum(__method__) unless block_given?

      each_ancestral_trait nil do |obj, trait|
        [*trait[:js]].each do |js|
          yield js if js
        end
      end
    end

    def js_assets
      each_js_asset.map{|js|
        %(<script src="#{h js}"></script>)
      }.join("\n")
    end
  end
end

require_relative 'main'
require_relative 'context'
require_relative 'super_admin'
require_relative 'admin'
