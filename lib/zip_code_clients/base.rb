module ZipCodeClients
  class ApiError < StandardError; end
  class ResponseError < StandardError; end
  class RateLimitError < StandardError; end

  class Base
    attr_reader :last_status, :last_headers, :last_error_message

    class << self
      def get_zip_code_details(zip_code)
        new.get_zip_code_details(zip_code)
      end
    end

    def initialize; end

    def get_zip_code_details(zip_code)
      raise NotImplementedError
    end

    def get(endpoint, query = {})
      make_request(:get, endpoint, query: query)
    end

    def post(endpoint, body = {})
      make_request(:post, endpoint, body: body)
    end

  private

    def make_request(method, endpoint, query: {}, body: {})
      query = parse_query(query)
      body = parse_body(body)

      url = query.present? ? "#{endpoint}?#{query}" : endpoint

      with_retries do
        ::HTTParty.public_send(method, url, request_options.merge(body: body)).tap do |resp|
          @last_status = resp.code
          @last_headers = resp.headers&.transform_keys(&:downcase)

          raise RateLimitError if last_status == 429
          raise ResponseError unless last_status / 100 == 2
        end
      end
    rescue => e
      raise ApiError, last_error_message unless [RateLimitError, ResponseError].include?(e.class)
      raise
    end

    def parse_query(query)
      return nil if query.blank?

      query.compact.to_query
    end

    def parse_body(data)
      return nil if data.blank?

      data.to_json
    end

    def request_options
      {
        timeout: 18,
        open_timeout: 2,
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json;charset=utf-8"
        }
      }
    end

    def with_retries
      retries ||= 0
      rate_limit_retries ||= 0
      yield
    rescue ResponseError
      if (retries += 1) < 3
        sleep(ENV["REQUEST_RETRY_DELAY_SECONDS"])
        retry
      end

      raise
    end
  end
end
