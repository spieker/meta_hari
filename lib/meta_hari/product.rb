module MetaHari
  class Product
    attr_reader :name
    attr_reader :image
    attr_reader :description

    def initialize(attributes = {})
      apply attributes
    end

    def apply(attributes)
      @name        = attributes['name']         if blank? name
      @image       = attributes['image']        if blank? image
      @description = attributes['description']  if blank? description
      self
    end

    private

    def blank?(value)
      value.nil? || value.empty?
    end
  end
end
