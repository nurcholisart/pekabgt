# frozen_string_literal: true

class Peka
  # Peka.new("ergav-4oqumerwmn4r1ud", "")

  DEFAULT_BASE_URL = "https://solitary-shape-3834.fly.dev"

  # Request
  # [
  #   "Most of the answers above require you to specify precision. But what if you want to display floats like this, with no unnecessary zeros:",
  #   "Most of the answers above require you to specify precision. But what if you want to display floats like this, with no unnecessary zeros:"
  # ]
  #
  #
  # Response
  # {
  #   "word_count": 120,
  #   "token_count": 135,
  #   "cost": "0.0000540"
  # }
  def initialize(app_code, api_key)
    @url = "#{DEFAULT_BASE_URL}/api/v1/#{app_code}"
    @app_code = app_code
    @api_key = api_key
  end

  def estimate_cost(strings)
    resp = HTTP.post("#{@url}/costs", json: strings)
    JSON.parse(resp.to_s, object_class: HashWithIndifferentAccess)
  end

  # Request
  # {
  #   "api_key": "--",
  #   "articles": [
  #     {
  #       "title": "How to Delete a Chat Room?",
  #       "link": "https://support.qiscus.com/hc/en-us/articles/900000639063-How-to-Delete-a-Chat-Room-",
  #       "content": "To delete a Qiscus chat room you only need to remove its' participants. You can easily remove the participants using our REST API. You can consult this documentation on how to do it https://documentation.qiscus.com/chat-server-api/chat-room#remove-participant-in-chat-room\n\nAfter you remove all participants, you'll no longer get the room when using load rooms API."
  #     }
  #   ]
  # }
  #
  #
  # Response
  # {
  #   "faiss_url": "https://dnlbo7fgjcc7f.cloudfront.net/ini-app-code/raw/upload/jujBD-vJuh/ini-app-code_embeddings_1683225014718.faiss",
  #   "pkl_url": "https://dnlbo7fgjcc7f.cloudfront.net/ini-app-code/raw/upload/57gy-viT_t/ini-app-code_embeddings_1683225014718.pkl"
  # }
  def create_embedding(articles)
    resp = HTTP.post("#{@url}/embeddings", json: {
                       api_key: @api_key,
                       articles: articles
                     })

    JSON.parse(resp.to_s, object_class: HashWithIndifferentAccess)
  end

  # Request
  # {
  #   "question": "Tolong hubungkan saya saja dengan agent. Mungkin human agent bisa lebih membantu!",
  #   "api_key": "",
  #   "faiss_url": "https://dnlbo7fgjcc7f.cloudfront.net/ini-app-code/raw/upload/jujBD-vJuh/ini-app-code_embeddings_1683225014718.faiss",
  #   "pkl_url": "https://dnlbo7fgjcc7f.cloudfront.net/ini-app-code/raw/upload/57gy-viT_t/ini-app-code_embeddings_1683225014718.pkl",
  #   "chat_history": []
  # }
  #
  #
  # Response
  # {
  #   "question": "Tolong hubungkan saya saja dengan agent. Mungkin human agent bisa lebih membantu!",
  #   "answer": " Maaf, saya hanya dapat menjawab pertanyaan tentang Qiscus. Silakan tunggu sebentar, saya akan menghubungkan Anda dengan agent untuk membantu Anda.#assign_agent",
  #   "chat_history": [],
  #   "source_documents": [
  #     {
  #       "page_content": "To delete a Qiscus chat room you only need to remove its' participants. You can easily remove the participants using our REST API. You can consult this documentation on how to do it https://documentation.qiscus.com/chat-server-api/chat-room#remove-participant-in-chat-room\n\nAfter you remove all participants, you'll no longer get the room when using load rooms API.",
  #       "metadata": {
  #         "title": "How to Delete a Chat Room?",
  #         "link": "https://support.qiscus.com/hc/en-us/articles/900000639063-How-to-Delete-a-Chat-Room-"
  #       }
  #     }
  #   ]
  # }
  def query_message(question, faiss_url, pkl_url, chat_history = [])
    resp = HTTP.post("#{@url}/chats", json: {
                       question: question,
                       api_key: @api_key,
                       faiss_url: faiss_url,
                       pkl_url: pkl_url,
                       chat_history: chat_history
                     })

    JSON.parse(resp.to_s, object_class: HashWithIndifferentAccess)
  end
end