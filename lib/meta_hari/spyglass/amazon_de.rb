module MetaHari
  module Spyglass
    class AmazonDe < Base
      def self.suitable?(uri)
        %w(amazon.de www.amazon.de).include? uri.host.downcase
      end

      def spy
        OpenStruct.new(name: title, image: image, description: '')
      end

      protected

      def title
        document.css('#productTitle').text
      end

      def image
        data = document.css('img#landingImage')
        data &&= data.attr 'data-old-hires'
        data && data.value
      end
    end
  end
end
