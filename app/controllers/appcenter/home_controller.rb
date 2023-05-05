# frozen_string_literal: true

module Appcenter
  class HomeController < BaseController
    before_action :authenticate_current_tenant

    def index; end
  end
end
