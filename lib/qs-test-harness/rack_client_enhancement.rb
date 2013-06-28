require 'rack/client'

module Rack
  module Client
    class Base
      def authorize_with(token)
        old_auth_token = @auth_token
        @auth_token = token
        if block_given?
          result = yield self
          @auth_token = old_auth_token
          result
        end
      end

      def reset_authorization
        @auth_token = nil
      end

      alias __original_request request
      def request(method, url, headers = {}, body = nil)
        headers['Authorization'] ||= "Bearer #{@auth_token}" if @auth_token

        __original_request(method, url, headers, body)
      end
    end
  end
end