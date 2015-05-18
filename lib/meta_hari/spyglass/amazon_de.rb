module MetaHari
  module Spyglass
    class AmazonDe < Base
      def self.suitable?(uri)
        %w(amazon.de www.amazon.de).include? uri.host.downcase
      end

      protected

      def spy_list
        [:spy_amazon]
      end

      def title
        document.css('#productTitle').text
      end

      def image
        data = document.css('img#landingImage')
        data &&= data.attr 'data-old-hires'
        data && data.value
      end

      def spy_amazon
        { 'name' => title, 'image' => image, 'description' => '' }
      end
    end
  end
end
