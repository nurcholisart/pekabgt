# frozen_string_literal: true

class Wordpress
  class RequestError < StandardError
  end

  def initialize(url)
    @url = Addressable::URI.parse(url)
  end

  def posts(page: 1, per_page: 100, order: "desc", orderby: "id")
    posts = []

    pagination, body = paginated_get(
      "/wp-json/wp/v2/posts",
      params: { page: page, per_page: per_page, order: order, orderby: orderby }
    )

    posts += body

    while page < pagination["total_page"]
      page += 1

      pagination, body = paginated_get(
        "/wp-json/wp/v2/posts",
        params: { page: page, per_page: per_page, order: order, orderby: orderby }
      )

      posts += body
    end

    posts.map do |post|
      content = post["content"]["rendered"]
      next if content.blank?

      content = ReverseMarkdown.convert content

      HashWithIndifferentAccess.new({
                                      id: post["id"],
                                      platform: "wordpress",
                                      created_at: post["date_gmt"],
                                      title: post["title"]["rendered"],
                                      content: content,
                                      link: post["link"]
                                    })
    end
  end

  private

  def paginated_get(path, options = {})
    full_url = @url.join(path)
    resp = HTTP.get(full_url, options.compact)
    raise RequestError, resp.to_s unless resp.status.success?

    body = JSON.parse(resp.to_s, object_class: HashWithIndifferentAccess)
    pagination = get_pagination_headers(resp.headers)

    [pagination, body]
  end

  #
  # @param [HTTP::Headers] headers
  #
  # @return [Hash]
  #
  def get_pagination_headers(headers)
    total = headers.get("X-WP-Total")&.first&.to_i || 0
    total_page = headers.get("X-WP-TotalPages")&.first&.to_i || 1

    HashWithIndifferentAccess.new({
                                    total: total || 0,
                                    total_page: total_page || 0
                                  })
  end

  def call(method, path, options = {})
    full_url = @url.join(path)

    resp = HTTP.request(method, full_url, options.compact)
    return JSON.parse(resp.to_s, object_class: HashWithIndifferentAccess) if resp.status.success?

    raise RequestError, resp.to_s
  end
end
