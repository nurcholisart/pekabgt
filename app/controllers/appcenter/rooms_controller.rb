# frozen_string_literal: true

module Appcenter
  class RoomsController < BaseController
    layout "widgets"

    before_action :authenticate_current_tenant

    def index; end

    def show
      @room_id = params[:id]
      @messages = Current.tenant.messages.where(qiscus_room_id: @room_id)
    end
  end
end
