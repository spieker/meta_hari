require 'spec_helper'

describe MetaHari::Helpers::OpenGraph do
  let(:url) do
    [
      'http://www.arzberg-porzellan.com/en/shop/products/bowls/sauce-boats',
      'sauceboat-0-35-l-form-1382-blaubluten/'
    ].join('/')
  end
  let(:html)     { resource_content('arzberg_porzellan.html') }
  let(:document) { Nokogiri::HTML html }
  let(:instance) { described_class.new document }
  subject        { instance }

  describe '#initialize' do
    it 'assigns the document to the reader' do
      expect(subject.document).to be document
    end
  end

  context 'when containing Open Graph data' do
    describe '#hash' do
      subject { instance.send :hash }

      it { should be_an Hash }
    end

    describe '#data' do
      subject { instance.data }

      it 'uses #hash' do
        expect(instance).to receive(:hash).and_return([])
        subject
      end

      it { should be_a Hash }
      it { should have_key 'name' }
      it { should have_key 'image' }
      it { should have_key 'description' }

      it 'has matching name' do
        expect(subject['name']).to eql 'Sauceboat 0.35 l FORM 1382 | BLAUBLÜTEN'
      end
    end
  end

  context 'when not containing Open Graph data' do
    let(:html) { '' }

    describe '#hash' do
      subject { instance.send :hash }

      it { should be_an Hash }
    end
  end
end
