module MetaHari
  module Helpers
    class JsonLd
      attr_reader :document

      def initialize(document)
        @document = document
      end

      def data(type = 'Product')
        (json['@type'] == type) ? json : {}
      end

      protected

      def selector
        'script[type="application/ld+json"]'
      end

      def json
        @json ||= begin
                    script = document.css(selector).first
                    return {} unless script
                    JSON.parse! script
                  end
      end
    end
  end
end
