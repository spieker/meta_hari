# MetaHari

Meta Hari is receiving product informations from a given product link
(i.e. from Amazon).

The name Meta Hari comes from
[Mata Hari](https://en.wikipedia.org/wiki/Mata_Hari), one of the most
popular spies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'meta_hari'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install meta_hari

## Usage

In order to receive product informations, just pass the URL containing
thous informations to the method `MetaHari.spy`.

```ruby
product = MetaHari.spy('http://www.amazon.de/Gastroback-42429-Design-Wasserkocher-Advanced/dp/B000LQXC2Q/ref=sr_1_1')
product.inspect # => #<MetaHari::Product:0x007fd9dba99158 @name="Gastroback 42429 Design Wasserkocher Advanced Pro", @image="http://ecx.images-amazon.com/images/I/814Yl6mxLsL._SL1500_.jpg", @description="">
```

## Implemented spyglasses

A spyglass is a support class for a specific shop. In order to support
custom shops which can not be spyed by the generic spyglass
(`MetaHari::Spyglass::Base`), a new spyglass has to be created.

* Amazon DE
* Generic
  * [JSON-LD](https://developers.google.com/structured-data/rich-snippets/products)
  * [Microdata](https://developers.google.com/structured-data/rich-snippets/products)
  * [Open Graph](http://ogp.me/)

### Creating a spyglass

A spyglass has to be a class within the namespace `MetaHari::Spyglass`
and must extend the class `MetaHari::Spyglass::Base`. The methods
`self.suitable?` and `spy`.

```ruby
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
```

## Contributing

1. Fork it ( https://github.com/spieker/meta_hari/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
