module Api
  class BaseController < ActionController::Base
    before_action :rate_limit_api_calls, :authorize

    private def rate_limit_api_calls
      if ApiRequest.by_ip(request.ip).after_time(1.hour.ago).count < ENV['public_api_request_limit'].to_i
        ApiRequest.create(client_ip: request.ip, path: request.path)
      else
        render plain: 'You reached your api request limit.'
      end
    end

    private def authorize
      unless request.headers['Auth-Token'].present? && (@user = User.find_by_auth_token(request.headers['Auth-Token']))
        render plain: 'Access Denied!'
      end
    end
  end
end
