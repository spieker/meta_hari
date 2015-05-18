require 'spec_helper'

describe MetaHari::Spyglass::BabyMarktDe do
  let(:uri) do
    URI.parse [
      'http://www.baby-markt.de/markenshop-big',
      'big-bobby-car/big-bobby-car-classic-rot-a006497.html'
    ].join('/')
  end
  let(:html)     { '' }
  let(:instance) { described_class.new uri }
  subject        { instance }

  before :each do
    allow(instance).to receive(:fetch_data).and_return(html)
  end

  it 'is suitable for baby-markt.de' do
    uri = URI.parse 'http://baby-markt.de'
    expect(described_class.suitable? uri).to be true
  end

  it 'is suitable for www.baby-markt.de' do
    uri = URI.parse 'http://www.baby-markt.de'
    expect(described_class.suitable? uri).to be true
  end

  context 'with valid amazn product page' do
    let(:html) { resource_content 'baby_markt_de.html' }

    it 'extracts the correct title' do
      expected_value = 'BIG Bobby Car Classic rot'
      expect(subject.send :title).to eql expected_value
    end

    it 'extracts the correct image' do
      expected_value = [
        'http://www.baby-markt.de/out/pictures/generated/product/1/390_390_80',
        'n_a006497_001.jpg?20150511132615'
      ].join('/')
      expect(subject.send :image).to eql expected_value
    end
  end

  describe '#spy' do
    let(:html) { resource_content 'baby_markt_de.html' }
    subject    { instance.spy }

    it { should be_an OpenStruct }
    it { should respond_to :name }
    it { should respond_to :image }
    it { should respond_to :description }
  end
end
