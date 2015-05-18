require 'spec_helper'

describe MetaHari::Spyglass::AmazonDe do
  let(:uri)      { URI.parse 'http://www.amazon.de/dp/B000LQXC2Q/ref=sr_1_1' }
  let(:html)     { '' }
  let(:instance) { described_class.new uri }
  subject        { instance }

  before :each do
    allow(instance).to receive(:fetch_data).and_return(html)
  end

  it 'is suitable for amazon.de' do
    uri = URI.parse 'http://amazon.de'
    expect(described_class.suitable? uri).to be true
  end

  it 'is suitable for www.amazon.de' do
    uri = URI.parse 'http://www.amazon.de'
    expect(described_class.suitable? uri).to be true
  end

  context 'with valid amazn product page' do
    let(:html) { resource_content 'amazon_de.html' }

    it 'extracts the correct title' do
      expected_value = 'Gastroback 42429 Design Wasserkocher Advanced Pro'
      expect(subject.send :title).to eql expected_value
    end

    it 'extracts the correct image' do
      expected_value =
        'http://ecx.images-amazon.com/images/I/814Yl6mxLsL._SL1500_.jpg'
      expect(subject.send :image).to eql expected_value
    end
  end

  describe '#spy' do
    let(:html) { resource_content 'amazon_de.html' }
    subject    { instance.spy }

    it { should be_an MetaHari::Product }
    it { should respond_to :name }
    it { should respond_to :image }
    it { should respond_to :description }
  end
end
