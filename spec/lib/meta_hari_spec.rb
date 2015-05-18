require 'spec_helper'

describe MetaHari do
  describe '#find_suitable_spyglass' do
    it 'returns a matching spy glass if it exists' do
      uri = URI.parse 'http://amazon.de'
      spyglass = MetaHari.send :find_suitable_spyglass, uri
      expect(spyglass).to be MetaHari::Spyglass::AmazonDe
    end

    it 'returns the base spyglass if no matching exists' do
      uri = URI.parse 'http://example.com'
      spyglass = MetaHari.send :find_suitable_spyglass, uri
      expect(spyglass).to be MetaHari::Spyglass::Base
    end
  end

  describe '#suitable_spyglass_instance' do
    it 'uses find_suitable_spyglass' do
      uri = URI.parse 'http://example.com'
      expect(MetaHari).to receive(:find_suitable_spyglass).with(uri).and_return(
        MetaHari::Spyglass::Base
      )
      MetaHari.send :suitable_spyglass_instance, uri
    end

    it 'creates an instance of the suitable class' do
      uri = URI.parse 'http://example.com'
      expect(MetaHari::Spyglass::Base).to receive(:new).with(uri)
      MetaHari.send :suitable_spyglass_instance, uri
    end

    it 'returns an instance of the suitable class' do
      uri = URI.parse 'http://example.com'
      spyglass = MetaHari.send :suitable_spyglass_instance, uri
      expect(spyglass).to be_instance_of MetaHari::Spyglass::Base
    end
  end
end
