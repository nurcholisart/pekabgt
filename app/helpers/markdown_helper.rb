# frozen_string_literal: true

require "redcarpet/render_strip"

module MarkdownHelper
  def markdown_to_plain(str)
    markdown = ::Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    markdown.render(str)
  end
end
