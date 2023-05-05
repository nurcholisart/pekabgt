# frozen_string_literal: true

module Appcenter
  class BaseController < ::ApplicationController
    include ActionView::RecordIdentifier # adds `dom_id`
  end
end
