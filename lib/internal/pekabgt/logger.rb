# frozen_string_literal: true

module Pekabgt
  class Logger < Ougai::Logger
    include ActiveSupport::LoggerThreadSafeLevel
    include ActiveSupport::LoggerSilence

    def initialize(*args)
      super
      after_initialize if respond_to?(:after_initialize) && ActiveSupport::VERSION::MAJOR < 6
    end

    def create_formatter
      Formatter.new
    end

    class Formatter < Ougai::Formatters::Bunyan
      def _call(severity, time, progname, data)
        data[:msg] = data[:msg].strip if data[:msg]

        log_data = {
          name: progname || @app_name,
          hostname: @hostname,
          pid: $PID,
          level: severity&.downcase,
          time: time,
          app_version: "undefined"
        }.merge(data)

        dump(log_data)
      end
    end
  end
end
