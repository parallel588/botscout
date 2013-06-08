require "botscout/version"
require  'httparty'

module Botscout
  class Client
    include HTTParty
    format :xml
    base_uri 'http://botscout.com'

    attr_accessor :key
    def initialize(key = "")
      @key = key
    end

    def test(options ={})
      _options = ((@key.nil? || @key.empty?)  ? {} : { :key => @key } ).merge(options)
      @response = self.class.get('/test/', :query => _options)

      Result.new(@response.body)
    end

    class Result
      attr_reader :response, :result, :matched

      def initialize(response = "")
        @response = response.to_s
        parse!
      end

      def bot?
        @result.to_s == "Y"
      end

      def success?
        !has_error?
      end

      def error
        @response.match(/\A!(.*)/) && $1
      end

      def has_error?
        !!@response.match(/\A!/)
      end

      private

      def parse!
        if has_error?
          @result = nil
        else
          results  = @response.split "|"
          @data =
            case results[1].to_s.downcase
            when "all" then parse_all(results)
            when "multi" then parse_multi(results)
            else
              parse_standart(results)
            end

          @result = @data[:matched]
        end

        self
      end


      def parse_standart(response_array)
        {
          :count => response_array[2].to_i,
          :field => response_array[1],
          :matched => response_array[0]
        }
      end

      def parse_all(response_array)
        {
          :count => response_array[2].to_i,
          :field => response_array[3],
          :matched => response_array[0]
        }
      end

      def parse_multi(response_array)
        {
          :count => response_array[2..-1].map(&:to_i).sum,
          :fields => Hash[*response_array[2..-1]],
          :matched => response_array[0]
        }
      end

    end
  end
end
