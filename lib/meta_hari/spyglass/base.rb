require 'ostruct'

module MetaHari
  module Spyglass
    class Base
      attr_reader :uri
      attr_reader :iteration

      def self.suitable?(uri)
        fail StandardError.new, "not implemented for '#{uri.host}'"
      end

      def initialize(uri, iteration = 0)
        @uri       = uri
        @iteration = iteration
      end

      def spy
        spy_list.map { |method| send method }
          .inject(MetaHari::Product.new 'uri' => uri) { |a, e| a.apply e }
      end

      protected

      def spy_list
        %i(spy_json_ld spy_microdata spy_open_graph)
      end

      def user_agent
        [
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5)',
          'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125',
          'Safari/537.36'
        ].join(' ')
      end

      def fetch_request
        path = uri.path.empty? ? '/' : uri.path
        Net::HTTP::Get.new path, 'User-Agent' => user_agent
      end

      def fetch_response
        Net::HTTP.start uri.host, uri.port do |http|
          http.request fetch_request
        end
      end

      def fetch_data
        return @_data if @_data
        case res = fetch_response
        when Net::HTTPSuccess
          @_data = res.body
        when Net::HTTPRedirection
          notification = RedirectNotification.new res['location'], iteration + 1
          fail notification, 'Redirection'
        else res.error!
        end
      end

      def document
        @document ||= Nokogiri::HTML fetch_data
      end

      def spy_json_ld
        json_ld = MetaHari::Helpers::JsonLd.new(document)
        json_ld.data
      end

      def spy_microdata
        microdata = MetaHari::Helpers::Microdata.new(document, uri.to_s)
        microdata.data
      end

      def spy_open_graph
        open_graph = MetaHari::Helpers::OpenGraph.new(document)
        open_graph.data
      end
    end
  end
end
