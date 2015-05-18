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

      it { should be_an OpenStruct }
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
  end
end
