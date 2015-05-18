module MetaHari
  module Spyglass
    class BabyMarktDe < Base
      def self.suitable?(uri)
        %w(baby-markt.de www.baby-markt.de).include? uri.host.downcase
      end

      def spy
        OpenStruct.new(name: title, image: image, description: '')
      end

      protected

      def title
        document.css('h1[itemprop="name"]').text
      end

      def image
        data = document.css('.product-image img')
        data &&= data.attr 'src'
        data && "http:#{data.value}"
      end
    end
  end
end
