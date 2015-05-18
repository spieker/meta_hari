module MetaHari
  module Helpers
    class OpenGraph
      attr_reader :document

      def initialize(document)
        @document = document
      end

      def data
        hash
      end

      protected

      def selector
        'meta[property^="og:"]'
      end

      def hash
        @hash ||= begin
                    result = {}
                    document.css(selector).each do |meta|
                      key   = meta.attr('property').to_s.gsub(/^og:/i, '')
                      value = meta.attr('content')
                      result[key_map(key)] = value
                    end
                    result
                  end
      end

      def key_map(key)
        case key.downcase
        when 'title' then 'name'
        else
          key.downcase
        end
      end
    end
  end
end
