require 'spec_helper'

describe MetaHari::Helpers::JsonLd do
  let(:html)     { resource_content('json_ld_example.html') }
  let(:document) { Nokogiri::HTML html }
  subject        { described_class.new document }

  describe '#initialize' do
    it 'assigns the document to the reader' do
      expect(subject.document).to be document
    end
  end

  context 'when containing JSON-LD' do
    describe '#json' do
      subject { described_class.new(document).send :json }

      it { should be_a Hash }
      it { should have_key '@context' }
      it { should have_key '@type' }
      it { should have_key 'name' }
      it { should have_key 'image' }
      it { should have_key 'description' }

      it 'is a product' do
        expect(subject['@type']).to eql 'Product'
      end
    end

    describe '#data' do
      it 'uses #json' do
        expect(subject).to receive(:json).and_return({})
        subject.data
      end

      context 'when type matches' do
        subject { described_class.new(document).data }

        it { should be_a Hash }
        it { should have_key '@context' }
        it { should have_key '@type' }
        it { should have_key 'name' }
        it { should have_key 'image' }
        it { should have_key 'description' }
      end

      context 'when type does not match' do
        subject { described_class.new(document).data('Something else') }

        it { should be_a Hash }
        it { should_not have_key '@context' }
        it { should_not have_key '@type' }
        it { should_not have_key 'name' }
        it { should_not have_key 'image' }
        it { should_not have_key 'description' }
      end
    end
  end

  context 'when not containing JSON-LD' do
    let(:html) { '' }

    describe '#json' do
      subject { described_class.new(document).send :json }

      it { should be_a Hash }
      it { should_not have_key '@context' }
      it { should_not have_key '@type' }
      it { should_not have_key 'name' }
      it { should_not have_key 'image' }
      it { should_not have_key 'description' }
    end
  end
end
