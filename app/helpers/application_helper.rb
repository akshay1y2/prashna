module ApplicationHelper
  def errors_explanation_div(model)
    return if model.errors.empty?
    content_tag(:div, id: "error_explanation") do
      header = "#{pluralize(model.errors.count, 'error')} prohibited this #{model.class.name} from being saved:"
      list_items = model.errors.full_messages.map { |msg| content_tag(:li, msg) }
      content_tag(:h2, header) + content_tag(:ul, list_items.join.html_safe)
    end
  end

  def markdown(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    Markdown.new(text, *options).to_html.html_safe
  end  
end
