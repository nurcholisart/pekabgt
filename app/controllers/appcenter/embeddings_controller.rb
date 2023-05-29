# frozen_string_literal: true

module Appcenter
  class EmbeddingsController < BaseController
    before_action :authenticate_current_tenant

    def index
      @embeddings = Current.tenant.embeddings.where.not(content: nil).order(id: :desc)
    end

    def create
      embedding = Current.tenant.embeddings.create
      redirect_to appcenter_embedding_imports_path(embedding)
    end

    def show
      @embedding = Current.tenant.embeddings.find(params[:id])
    end

    def train
      @embedding = Current.tenant.embeddings.find(params[:id])

      content_for_embed = []
      @embedding.hashed_contents.each do |content|
        content_for_embed.append({
                                   title: content[:title],
                                   link: content[:link],
                                   content: content[:content]
                                 })
      end

      peka = Peka.new(@embedding.tenant.code, @embedding.tenant.openai_api_key)
      result = peka.create_embedding(content_for_embed)

      @embedding.update(faiss_url: result[:faiss_url], pkl_url: result[:pkl_url], status: "success")

      redirect_to appcenter_embedding_path(@embedding), notice: "Training success!"
    end

    def update
      @embedding = Current.tenant.embeddings.find(params[:id])

      new_contents = []

      contents = params[:embedding][:content] || []
      contents.each do |content|
        new_contents.append(content) if content[:checked].present?
      end

      peka = Peka.new(Current.tenant.code, Current.tenant.openai_api_key)

      if new_contents.present?
        @embedding.content = new_contents.to_json
        if @embedding.content_changed?
          estimated_cost = peka.estimate_cost(new_contents.pluck(:content))[:cost]
          @embedding.cost = estimated_cost
        end

        @embedding.save
      end

      redirect_to appcenter_embedding_path(@embedding)
    end

    def activation
      @embedding = Current.tenant.embeddings.find(params[:id])

      if ActiveModel::Type::Boolean.new.cast(params[:active])
        Current.tenant.embeddings.active.update_all(active: false)
        @embedding.update(active: true)

        redirect_to appcenter_embedding_path(@embedding), notice: "Success activated Embedding"
      else
        existed_active_embedding = Current.tenant.embeddings.find_by(active: true)
        if existed_active_embedding.blank?
          redirect_to appcenter_embedding_path(@embedding), alert: "You must atleast has one active embedding"
        else
          @embedding.update(active: false)
          redirect_to appcenter_embedding_path(@embedding), notice: "Success deactivated embedding"
        end
      end
    end

    def destroy
      @embedding = Current.tenant.embeddings.find(params[:id])
      @embedding.destroy

      redirect_to appcenter_embeddings_path, notice: "Success delete"
    end
  end
end
