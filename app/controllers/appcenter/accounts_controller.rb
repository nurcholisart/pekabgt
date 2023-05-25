# frozen_string_literal: true

module Appcenter
  class AccountsController < BaseController
    before_action :authenticate_current_tenant

    def index; end

    def create
      Current.tenant.update(create_params)
      redirect_to appcenter_accounts_path, notice: "Update success!"
    end

    private

    def create_params
      params.require(:tenant).permit(:openai_api_key)
    end
  end
end