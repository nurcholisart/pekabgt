# frozen_string_literal: true

Rails.application.configure do
  if Rails.env.production? || ENV["LOGRAGE_ENABLED"]
    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Raw.new # We will use Ougai to jsonify log data
    config.lograge.custom_options = lambda do |event|
      {
        user_agent: event.payload[:user_agent],
        time: Time.zone.now,
        host: event.payload[:host],
        protocol: event.payload[:protocol],
        remote_ip: event.payload[:remote_ip],
        ip: event.payload[:ip],
        x_forwarded_for: event.payload[:x_forwarded_for],
        params: event.payload[:params],
        exception: event.payload[:exception]&.first,
        request_id: event.payload.try(:headers).try("action_dispatch.request_id"),
        msg: (event.payload[:message] || "request_log").strip
      }.compact
    rescue StandardError
      {}
    end
  end
end
