# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authable

  def append_info_to_payload(payload)
    super

    payload[:host] = request.host
    payload[:remote_ip] = request.remote_ip
    payload[:ip] = request.ip
    payload[:user_agent] = request.user_agent
    payload[:protocol] = request.protocol

    user_params = params.as_json
    user_params = user_params.except("controller", "action")

    payload[:params] = user_params

    payload[:message] = lograge_message
  end

  def lograge_message
    @lograge_message ||= "no message"
  end
end
