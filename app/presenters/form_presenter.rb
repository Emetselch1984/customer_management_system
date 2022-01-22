class FormPresenter
  include HtmlBuilder
  include Ransack
  attr_reader :form_builder, :view_context

  delegate :label, :text_field, :date_field, :password_field,
           :check_box, :radio_button, :text_area, :object,
           :search_field, :collection_select, :number_field,
           to: :form_builder

  def initialize(form_builder, view_context)
    @form_builder = form_builder
    @view_context = view_context
  end

  def notes
    markup(:div, class: 'notes') do |m|
      m.span '*', class: 'mark'
      m.text '印の付いた項目は入力必須です。'
    end
  end

  def text_field_block(name, label_text, options = {})
    markup(:div, class: 'input-block') do |m|
      m << decorated_label(name, label_text, options)
      m << text_field(name, options)
      m.span "#{options[:maxlength]}文字以内", class: 'instruction' if options[:maxlength]
      m << error_messages_for(name)
    end
  end

  def text_search_block(name, label_text, options = {})
    markup(:div, class: 'input-block') do |m|
      m << decorated_label(name, label_text, options)
      m << search_field(name, options)
    end
  end

  def number_field_block(name, label_text, options = {})
    markup(:div) do |m|
      m << decorated_label(name, label_text, options)
      m << form_builder.number_field(name, options)
      if options[:max]
        max = view_context.number_with_delimiter(options[:max].to_i)
        m.span "（最⼤値: #{max}）", class: 'instruction'
      end
      m << error_messages_for(name)
    end
  end

  def password_field_block(name, label_text, options = {})
    markup(:div, class: 'input-block') do |m|
      m << decorated_label(name, label_text, options)
      m << password_field(name, options)
      m << error_messages_for(name)
    end
  end

  def date_field_block(name, label_text, options = {})
    markup(:div, class: 'input-block') do |m|
      m << decorated_label(name, label_text, options)
      m << date_field(name, options)
      m << error_messages_for(name)
    end
  end

  def error_messages_for(name)
    markup do |m|
      object.errors.full_messages_for(name).each do |message|
        m.div(class: 'error-message') do |mm|
          mm.text message
        end
      end
    end
  end

  def drop_down_list_block(name, label_text, choices, options = {})
    markup(:div, class: 'input-block') do |m|
      m << decorated_label(name, label_text, options)
      m << form_builder.select(name, choices, { include_blank: true }, options)
      m << error_messages_for(name)
    end
  end

  def drop_down_search_block(name, label_text, choices)
    markup(:div, class: 'input-block') do |m|
      m << decorated_label(name, label_text)
      m << form_builder.select(name, choices, { include_blank: true })
    end
  end

  def text_area_block(name, label_text, options = {})
    markup(:div, class: 'input-block') do |m|
      m << decorated_label(name, label_text, options)
      m << text_area(name, options)
      m.span "#{options[:maxlength]}文字以内", class: 'instruction', style: 'float: right' if options[:maxlength]
    end
    m << error_messages_for(name)
  end

  def decorated_label(name, label_text, options = {})
    label(name, label_text, class: options[:required] ? 'required' : nil)
  end
end

