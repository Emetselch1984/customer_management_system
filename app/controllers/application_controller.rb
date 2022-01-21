class ApplicationController < ActionController::Base
  layout :set_layout

  # include ErrorHandlers

  private

  def set_layout
    if params[:controller].match(%r{\A(staff|admin|customer|test)/})
      Regexp.last_match[1]
    else
      'customer'
    end
  end
end
