# frozen_string_literal: true

module ApplicationHelper
  def render_svg(name, options = {})
    filename = if name.end_with?(".svg")
                 name
               else
                 "#{name}.svg"
               end

    inline_svg_tag(filename, options)
  end

  def chatbot_webhook_url(tenant)
    base_url = if request.host == "localhost"
                 "http://localhost:3000"
               elsif request.protocol.start_with?("http://")
                 "http://#{request.host}"
               else
                 "https://#{request.host}"
               end

    "#{base_url}/webhooks/chatbot/#{tenant.code}"
  end

  def remove_action_message(text)
    text = text.gsub("#small_talk", "")
    text = text.gsub("#end_chat", "")
    text = text.gsub("#assign_agent", "")
    text = text.gsub("#dont_know", "")
    text.strip
  rescue StandardError
    text
  end

  def text_to_true_link(text)
    urls = URI.extract(text, %w[http https])
    urls.each do |url|
      url = url.delete_suffix(".")
      url = url.delete_suffix(",")

      text.gsub!(url, "<a href=#{url} target='_blank' class='text-cyan-400'>#{url}</a>")
    end
    text.html_safe
  rescue StandardError
    text
  end

  def import_platforms
    [
      {
        name: "Wordpress",
        available: true
      },
      {
        name: "Zendesk",
        available: false
      },
      {
        name: "Joomla",
        available: false
      },
      {
        name: "HTML Scrape",
        available: false
      },
      {
        name: "File Upload",
        available: false
      }
    ]
  end
end
