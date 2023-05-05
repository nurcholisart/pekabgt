# frozen_string_literal: true

class Wordpress
  class RequestError < StandardError
  end

  def initialize(url)
    @url = Addressable::URI.parse(url)
  end

  def posts(page: 1, per_page: 100, order: "desc", orderby: "id")
    posts = call(:get, "/wp-json/wp/v2/posts",
                 params: { page: page, per_page: per_page, order: order, orderby: orderby })

    posts.map do |post|
      {
        id: post["id"],
        platform: "wordpress",
        created_at: post["date_gmt"],
        title: post["title"]["rendered"],
        content: post["content"]["rendered"],
        link: post["link"]
      }
    end
  end

  private

  def call(method, path, options = {})
    full_url = @url.join(path)

    resp = HTTP.request(method, full_url, options.compact)
    return JSON.parse(resp.to_s, object_class: HashWithIndifferentAccess) if resp.status.success?

    raise RequestError, resp.to_s
  end
end
