require 'addressable/uri'

# The AddressableFactory helper is trying to guess a URL out of a given string.
#
# Example
# -------
# ```ruby
# uri = MetaHari::Helpers::AddressableFactory.parse('example.com/foo')
# # => http://example.com/foo
# ```
#
module MetaHari
  module Helpers
    module AddressableFactory
      class <<self
        def parse(url)
          uri = Addressable::URI.parse(url)
          fix_scheme uri
          fix_host uri
          uri
        end

        private

        def fix_scheme(uri)
          uri.scheme ||= 'http'
        end

        def fix_host(uri)
          return unless uri.host.nil?
          host, *path = uri.path.split('/')
          uri.path = '/' + path.join('/')
          uri.host = host
        end
      end
    end
  end
end
