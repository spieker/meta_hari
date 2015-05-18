require 'nokogiri'
require 'json'
require 'uri'
require 'net/http'
require 'microdata'
require 'meta_hari/version'
require 'meta_hari/helpers'
require 'meta_hari/product'
require 'meta_hari/spyglass'

# MetaHary will find product informations for a given product link. The
# information will be wrapped into an OpenStruct.
#
# Example
# =======
#
# ```ruby
# product = MetaHari.spy('http://example.com/product.html')
# ```
module MetaHari
  class <<self
    def spy(url)
      uri = URI.parse url
      spyglass = suitable_spyglass_instance uri
      spyglass.spy
    end

    private

    def suitable_spyglass_instance(uri)
      klass = find_suitable_spyglass(uri)
      klass.new(uri)
    end

    # Finding a suitable spyglass for the given URL. If no suitable spyglass
    # is found, the default spyglass (MetaHari::Spyglass::Base) is returned.
    #
    def find_suitable_spyglass(uri)
      spyglasses = MetaHari::Spyglass.constants.map do |c|
        MetaHari::Spyglass.const_get(c)
      end
      spyglasses.select! { |spyglass| spyglass < MetaHari::Spyglass::Base }
      suitable_spyglass = spyglasses.find { |spyglass| spyglass.suitable? uri }
      suitable_spyglass || MetaHari::Spyglass::Base
    end
  end
end
