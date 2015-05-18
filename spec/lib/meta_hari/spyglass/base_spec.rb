require 'spec_helper'

describe MetaHari::Spyglass::Base do
  let(:uri)  { URI.parse 'http://example.com:8080/product.html' }
  let(:path) { '/product.html' }
  subject    { described_class.new uri }

  describe '#fetch_request' do
    it 'creates a new GET request' do
      expect(Net::HTTP::Get).to receive(:new).with(
        path, 'User-Agent' => subject.send(:user_agent)
      )
      subject.send :fetch_request
    end

    it 'returns a GET request instance' do
      expect(subject.send :fetch_request).to be_instance_of Net::HTTP::Get
    end
  end

  describe '#fetch_data' do
    it 'starts a new HTTP request' do
      expect(Net::HTTP).to receive(:start).with(
        uri.host, uri.port
      ).and_return OpenStruct.new(:'error!' => nil)
      subject.send :fetch_data
    end

    it 'fails when redirection limit is zero' do
      expect do
        subject.send :fetch_data, 0
      end.to raise_exception
    end

    it 'fires an http request' do
      http = OpenStruct.new request: nil
      fetch_request = subject.send :fetch_request
      allow(subject).to receive(:fetch_request).and_return fetch_request
      expect(http).to receive(:request).with(fetch_request)
      allow(Net::HTTP).to receive(:start).with(
        uri.host, uri.port
      ).and_yield(http).and_return OpenStruct.new(:'error!' => nil)
      subject.send :fetch_data
    end
  end

  describe '#spy' do
    context 'with JSON-DL document' do
      let(:instance) { described_class.new(uri) }
      let(:html)     { resource_content 'json_ld_example.html' }
      subject { instance.spy }

      before :each do
        allow(instance).to receive(:fetch_data).and_return(html)
      end

      it { should be_an MetaHari::Product }
      it { should respond_to :name }
      it { should respond_to :image }
      it { should respond_to :description }

      it 'has the correct name' do
        expect(subject.name).to eql 'Executive Anvil'
      end

      it 'has the correct image url' do
        expected_value = 'http://www.example.com/anvil_executive.jpg'
        expect(subject.image).to eql expected_value
      end

      it 'has the correct description' do
        expected_value = [
          'Sleeker than ACME\'s Classic Anvil, the Executive Anvil is perfect',
          'for the business traveler looking for something to drop from a',
          'height.'
        ].join(' ')
        expect(subject.description).to eql expected_value
      end
    end

    context 'with Microdata document' do
      let(:uri)  { URI.parse 'http://baby-markt.de/' }
      let(:instance) { described_class.new(uri) }
      let(:html)     { resource_content 'baby_markt_de.html' }
      subject { instance.spy }

      before :each do
        allow(instance).to receive(:fetch_data).and_return(html)
      end

      it { should be_an MetaHari::Product }
      it { should respond_to :name }
      it { should respond_to :image }
      it { should respond_to :description }

      it 'has the correct name' do
        expect(subject.name).to eql 'BIG Bobby Car Classic rot'
      end

      it 'has the correct image url' do
        expected_value = [
          'http://www.baby-markt.de/out/pictures/generated/product/1',
          '390_390_80/n_a006497_001.jpg?20150511132615'
        ].join('/')
        expect(subject.image).to eql expected_value
      end

      it 'has the correct description' do
        expected_value = [
          'BIG Bobby Car ClassicArtikelnummer: 800001303 Dank des',
          'kindgerechten Designs, der unverwüstlichen Konstruktion und der',
          'vielseitigen Funktionalität iist das BIG Bobby Car Classic das',
          'meistgekaufte Kinderrutsch-fahrzeug der Welt. Und dabei macht BIG',
          'Bobby...'
        ].join(' ')
        expect(subject.description).to eql expected_value
      end
    end

    context 'with Open Graph document' do
      let(:html)     { resource_content 'arzberg_porzellan.html' }
      let(:instance) { described_class.new(uri) }
      subject        { instance.spy }

      before :each do
        allow(instance).to receive(:fetch_data).and_return(html)
      end

      it { should be_an MetaHari::Product }
      it { should respond_to :name }
      it { should respond_to :image }
      it { should respond_to :description }

      it 'has the correct name' do
        expect(subject.name).to eql 'Sauceboat 0.35 l FORM 1382 | BLAUBLÜTEN'
      end

      it 'has the correct image url' do
        expected_value = [
          'http://arzberg-c00.kxcdn.com/cache/dc/db',
          'dcdbb5956e1f9fb60de351fbd21a9c4d.jpg'
        ].join('/')
        expect(subject.image).to eql expected_value
      end

      it 'has the correct description' do
        expected_value = [
          'Order online our Sauceboat 0.35 l FORM 1382 | BLAUBLÜTEN. ✓ Large',
          'Range ✓ Best Quality ✓ Directly from the Manufacturer ▻',
          'Arzberg-Porzellan.com'
        ].join(' ')
        expect(subject.description).to eql expected_value
      end
    end
  end
end
