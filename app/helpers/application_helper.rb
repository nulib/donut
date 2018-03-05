module ApplicationHelper
  def status_label(status)
    status_span_generator status
  end

  private

    def status_span_generator(status)
      case status
      when 'error'
        content_tag(:span, " #{status.titleize}", class: 'fa fa-exclamation-triangle')
      when 'complete'
        content_tag(:span, " #{status.titleize}", class: 'fa fa-check-circle')
      when 'initialized'
        content_tag(:span, " #{status.titleize}", class: 'fa fa-info')
      when 'empty'
        content_tag(:span, " #{status.titleize}", class: 'fa fa-minus-circle')
      when 'processing'
        content_tag(:span, " #{status.titleize}", class: 'fa fa-sync')
      end
    end
end
