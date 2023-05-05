# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :tenant

  class << self
    # @!method tenant=(tenant)
    #   @return [NilClass]

    # @!method tenant
    #   @return [Tenant]
  end
end
