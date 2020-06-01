module Api
  class BaseController < ActionController::Base
    before_action :rate_limit_api_calls, :authorize
    around_action :save_api_request

    private def rate_limit_api_calls
      unless ApiRequest.by_ip(request.ip).after_time(30.second.ago).count < ENV['public_api_request_limit'].to_i
        render json: {error: 'You reached your api request limit.'}, status: 429
      end
    end

    private def authorize
      unless request.headers['Auth-Token'].present? && (@user = User.find_by_auth_token(request.headers['Auth-Token']))
        render json: {error: 'Unauthorized Request!'}, status: 401
      end
    end

    private def save_api_request
      ApiRequest.create(client_ip: request.ip, path: request.path)
      yield
    end
  end
end


