# frozen_string_literal: true

module Appcenter
  class ImportsController < BaseController
    before_action :authenticate_current_tenant

    def index
      @url = "https://kenowlejbes.000webhostapp.com"
      @embedding = Current.tenant.embeddings.find(params[:embedding_id])
      @articles = JSON.parse(@embedding.content || [].to_json)
    end

    def create
      @embedding = Current.tenant.embeddings.find(params[:embedding_id])

      wp = Wordpress.new(params[:url])
      @articles = wp.posts(per_page: 50)

      @embedding.update(content: @articles.to_json)

      redirect_to appcenter_embedding_imports_path(@embedding)
    end
  end
end
