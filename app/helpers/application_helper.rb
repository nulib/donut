module ApplicationHelper
  def error_collector(error_hash)
    return 'No errors' if error_hash.empty?
    error_hash.collect do |field, errors|
      errors.collect { |error| "#{field}: #{error} "}
    end.flatten.join('<br/>')
  end

  def status_context(status)
    case status
    when 'error'       then 'danger'
    when 'complete'    then 'success'
    when 'initialized' then 'info'
    when 'processing'  then 'active'
    else ''
    end
  end

  def status_label(status)
    status_span_generator status
  end

  private

    def status_span_generator(status)
      fa_class = case status
      when 'error' then 'fa fa-exclamation-triangle'
      when 'complete' then 'fa fa-check-circle'
      when 'initialized' then 'fa fa-info'
      when 'empty' then 'fa fa-minus-circle'
      when 'processing' then 'fa fa-sync'
      end
      content_tag(:span, class: fa_class) do
        ('&ensp;' + content_tag(:a, status.titleize)).html_safe
      end
    end
end
