module MetaHari
  module Helpers
    class Microdata
      attr_reader :document
      attr_reader :url

      def initialize(document, url)
        @document = document
        @url      = url
      end

      def data(type = 'http://schema.org/Product')
        result = array.find { |hash| hash[:type].include? type }
        result && format(result) || {}
      end

      protected

      def format(result)
        data = result[:properties]
        {
          '@type'       => result[:type] && result[:type].first,
          'name'        => data['name'] && data['name'].first,
          'image'       => data['image'] && data['image'].first,
          'description' => data['description'] && data['description'].first
        }
      end

      def array
        @hash ||= items.map(&:to_hash)
      end

      def items
        itemscopes = document.search('//*[@itemscope and not(@itemprop)]')
        return [] unless itemscopes
        itemscopes.collect do |itemscope|
          ::Microdata::Item.new(itemscope, url)
        end
      end
    end
  end
end
