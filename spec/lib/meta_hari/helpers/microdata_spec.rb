require 'spec_helper'

describe MetaHari::Helpers::Microdata do
  let(:url) do
    [
      'http://www.baby-markt.de/markenshop-big',
      'big-bobby-car/big-bobby-car-classic-rot-a006497.html'
    ].join('/')
  end
  let(:html)     { resource_content('baby_markt_de.html') }
  let(:document) { Nokogiri::HTML html }
  let(:instance) { described_class.new document, url }
  subject        { instance }

  describe '#initialize' do
    it 'assigns the document to the reader' do
      expect(subject.document).to be document
    end
  end

  context 'when containing Microdata' do
    describe '#hash' do
      subject { instance.send :array }

      it { should be_an Array }
    end

    describe '#data' do
      it 'uses #array' do
        expect(subject).to receive(:array).and_return([])
        subject.data
      end

      context 'when type matches' do
        subject { instance.data }

        it { should be_a Hash }
        it { should have_key '@type' }
        it { should have_key 'name' }
        it { should have_key 'image' }
        it { should have_key 'description' }

        it 'is a product' do
          expect(subject['@type']).to eql 'http://schema.org/Product'
        end

        it 'has matching name' do
          expect(subject['name']).to eql 'BIG Bobby Car Classic rot'
        end
      end

      context 'when type does not match' do
        subject { instance.data('http://schema.org/Foo') }

        it { should be_a Hash }
        it { should_not have_key '@type' }
        it { should_not have_key 'name' }
        it { should_not have_key 'image' }
        it { should_not have_key 'description' }
      end
    end
  end

  context 'when not containing Microdata' do
    let(:html) { '' }

    describe '#array' do
      subject { instance.send :array }

      it { should be_an Array }
    end
  end
end
