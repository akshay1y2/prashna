class AnswerPresenter < ApplicationPresenter
  presents :answer

  @delegation_methods = [:content]

  delegate *@delegation_methods, to: :answer

  def render_content
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    Markdown.new(content, *options).to_html.html_safe
  end
end
