require 'spec_helper'

describe MetaHari::Helpers::AddressableFactory do
  subject { described_class }

  it { should respond_to :parse }

  it 'is not changing a valid URL' do
    uri = subject.parse 'https://example.com/foo'
    expect(uri.to_s).to eql 'https://example.com/foo'
  end

  context 'without scheme' do
    it 'adds http as default scheme' do
      uri = subject.parse '//example.com/foo'
      expect(uri.to_s).to eql 'http://example.com/foo'
    end
  end

  context 'without a host' do
    it 'uses the first part of the path as host' do
      uri = subject.parse 'example.com/foo'
      expect(uri.to_s).to eql 'http://example.com/foo'
    end

    it 'works with an empty path' do
      uri = subject.parse 'example.com'
      expect(uri.to_s).to eql 'http://example.com/'
    end
  end
end
