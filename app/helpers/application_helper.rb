module ApplicationHelper
  include HtmlBuilder
  def document_title
    if @title.present?
      "#{@title} - CustomerManagementSystem"
    else
      'CustomerManagementSystem'
    end
  end
end
